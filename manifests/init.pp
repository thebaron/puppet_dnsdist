# Class: dnsdist
#
# This class installs and manages dnsdist
#
# Author
#   Michiel Piscaer <michiel@piscaer.com>
#
# Version
#   0.1   Initial release
#
# Parameters:
#   $webserver = '0.0.0.0:80',
#   $webserver_pass = 'geheim'
#   $control_socket = '127.0.0.1'
#   $listen_addresess = '0.0.0.0'
#
# Requires:
#   concat
#   apt
#
# Sample Usage:
#
#   class { 'dnsdist':
#    webserver        => '192.168.1.1:80',
#    listen_addresess => [ '192.168.1.1' ];
#  }
#
class dnsdist (
  $webserver        = '0.0.0.0:80',
  $webserver_pass   = 'geheim',
  $control_socket   = '127.0.0.1',
  $listen_addresess = '0.0.0.0',
  $enable_repo      = true,
  $carbon_server    = '',
  $carbon_period    = 30,
) {

  class { 'dnsdist::install':
    enable_repo => $enable_repo
  }

  concat { "/etc/dnsdist/dnsdist.conf":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service['dnsdist'],
    require => [Package['dnsdist']]
  }

  concat::fragment { "global-header":
    target  => "/etc/dnsdist/dnsdist.conf",
    content => template('dnsdist/dnsdist.conf-header.erb'),
    order   => '10';
  }

  concat::fragment { "acl-header":
    target  => "/etc/dnsdist/dnsdist.conf",
    content => 'setACL({',
    order   => '40';
  }

  concat::fragment { "acl-footer":
    target  => "/etc/dnsdist/dnsdist.conf",
    content => "})\n",
    order   => '49';
  }

  service { 'dnsdist':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [Concat['/etc/dnsdist/dnsdist.conf']]
  }
}
