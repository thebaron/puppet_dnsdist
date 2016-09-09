# install.pp

class dnsdist::install(
  $enable_repo = true,
) {

  if $enable_repo {

    case $::osfamily {

      'debian': {
        apt::pin { 'dnsdist':
          origin   => 'repo.powerdns.com',
          priority => '600'
        }

        apt::key { 'powerdns':
          key         => 'FD380FBB',
          key_content => template('dnsdist/aptkey.erb'),
        }

        apt::source { 'repo.powerdns.com':
          location    => 'http://repo.powerdns.com/ubuntu',
          repos       => 'main',
          release     => 'trusty-dnsdist-10',
          include_src => false,
          amd64_only  => true,
          require     => [Apt::Pin['dnsdist'], Apt::Key['powerdns']],
          notify      => Package['dnsdist-10']
        }
      }

      'redhat': {
        yumrepo { 'powerdns-dnsdist-10':
          enabled  => 1,
          descr    => 'dnsdist 1.0 repository',
          baseurl  => 'http://repo.powerdns.com/centos/x86_64/7/dnsdist-10',
          gpgcheck => 1,
        }

        exec { 'import dnsdist gpg key':
          command => 'rpm --import https://repo.powerdns.com/FD380FBB-pub.asc',
          unless  => "rpm -qa --nodigest --nosignature --qf '%{VERSION}-%{RELEASE} %{SUMMARY}\n' | grep fd380fbb",
          path    => [ '/bin', '/usr/bin', '/sbin', '/usr/sbin' ],
          require => Yumrepo['powerdns-dnsdist-10'],
          notify  => Package['dnsdist-10']
        }
      }
    }
  } # enable_repo

  package { 'dnsdist-10':
    ensure => present,
    name   => 'dnsdist'
  }

}
