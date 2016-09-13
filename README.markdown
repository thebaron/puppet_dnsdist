# dnsdist puppet module

Module to manage dnsdist on Debian/Ubuntu and RedHat/Centos/Scientific Linux.

## Modules required
- concat
- apt (for Debian-based hosts)

## Example

### init

```
  class { 'dnsdist':
    webserver        => '192.168.1.1:80',
    listen_addresess => [ '192.168.1.1' ],
    carbon_server    => '192.168.50.1',
  }
```
#### Configure backend servers
```
  dnsdist::newserver { '192.168.2.1':
    pool => 'poolname',
    resolver_name => 'ns1';
  }
```

#### Configure ACL
```
  dnsdist::acl { [
    '192.168.1.0/24']:
  }
```

#### Configure actions
```
  dnsdist::addaction {
    'adddelay_0ms_at_300_qps':
      action => 'addDelay(MaxQPSIPRule(300, 32, 48), 0)',
      order  => 1;
  }
```

#### Configure pools
```
   dnsdist::addpoolrule {
     'pool_name':
       rules => ['local.', 'intern.', '10.in-addr.arpa', '16.172.in-addr.arpa', '17.172.in-addr.arpa'],
       pool  => 'poolname';
   }
```
