# default path
Exec {
  path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

include bootstrap
include tools
include nginx
include php
include php::pear
include php::pecl
include mysql
include postfix
include dovecot
include ssl
include owncloud
include roundcube
include postfixadmin
include backup2l
include shorewall
include postfix::config
include dovecot::config
include nginx::config
include owncloud::config
include roundcube::config
include postfixadmin::config
include backup2l::config
include shorewall::config
