# Define: dnsdist::addcache
#
#  adds a cache to a pool
#
# Author
#   Baron Chandler <baron@baronchandler.com>
#
# Version
#   0.1   Initial release
#
# Parameters (see cachine docs at dnsdist.org for details):
#   $pool (defaults to global)
#   $size (defaults to 10,000 entries)
#   $max_life (1 day)
#   $min_ttl_to_cache (0 seconds)
#   $srv_fail_ttl (60 seconds)
#   $stale_ttl (60 seconds)
#
# Requires:
#
# Sample Usage:
#
#   dnsdist::addcache { 'setup global cache': }
#
#   dnsdist::addcache { 'add abuse pool cache':
#               pool => 'abuse', }
#

define dnsdist::addcache ($pool='', $varname='', $size=10000, $max_life=86400, $min_ttl_to_cache=0, $srv_fail_ttl=60, $stale_ttl=60) {
  concat::fragment { "addcache-${order}-${title}":
    target  => "/etc/dnsdist/dnsdist.conf",
    content => "pc_${order} = newPacketCache(${size}, ${max_life}, ${min_ttl_to_cache}, ${srv_fail_ttl}, ${$stale_ttl}\
        getPool(\"${pool}\"):setCache(pc_${order})\n",
    order   => "60"
  }
}