############
#Setup nginx
############

package {"nginx":
  ensure => present
}

service { "nginx": 
    enable => true, 
    ensure => "running",
    require => Package['nginx']
}

file { "/etc/nginx/nginx.conf":
  source =>   "file:///repos/server/conf/nginx.conf",
  notify => Service["nginx"],
  require => Package['nginx'],
  mode   => 644
}

file { "/etc/nginx/conf.d/default.conf":
  source =>   "file:///repos/server/conf/default.conf",
  notify => Service["nginx"],
  require => Package['nginx'],
  mode   => 644
}

file { "/etc/nginx/conf.d/wordpress.conf":
  source =>   "file:///repos/server/conf/wordpress.conf",
  notify => Service["nginx"],
  require => Package['nginx'],
  mode   => 644
}

file { "/etc/nginx/conf.d/phpmyadmin.conf":
  source =>   "file:///repos/server/conf/phpmyadmin.conf",
  notify => Service["nginx"],
  require => Package['nginx'],
  mode   => 644
}

file { "/etc/nginx/conf.d/bespectacled.conf":
  source =>   "file:///repos/server/conf/bespectacled.conf",
  notify => Service["nginx"],
  require => Package['nginx'],
  mode   => 644
}

file { "/var/log/nginx":
  require => Package['nginx'],
  ensure => "directory",
  recurse => true,
  mode   => 777
}

##########
#Setup php
##########

package {"php-fpm":
  ensure => present
}

service { "php-fpm": 
    enable => true, 
    ensure => "running",
    require => Package['php-fpm']    
}

package {"php-mysql":
  ensure => present,
  notify => Service['php-fpm']
}

package {"php-cli":
  ensure => present,
  notify => Service['php-fpm']
}

#not required for debian?
package {"php-mbstring":
  ensure => present,
  notify => Service['php-fpm']
}

package {"php-mcrypt":
  ensure => present,
  notify => Service['php-fpm']
}

file { "/etc/php.ini":
  source =>   "file:///repos/server/conf/php.ini",
  require => Package['php-fpm'],
  notify => Service['php-fpm'],
  mode   => 644
}

file { "/etc/php-fpm.d/www.conf":
  source =>   "file:///repos/server/conf/www.conf",
  require => Package['php-fpm'],
  notify => Service['php-fpm'],
  mode   => 644
}

# apache user specified in /etc/php-fpm.d/www.conf
file { "/var/lib/php/session":
    ensure => "directory",
    owner  => "nginx",
    mode   => 700,
    require => Package['php-fpm']
}

##########
#mysql
##########
class { 'mysql::server':
  config_hash => { 'root_password' => 'rF2v6tx4qYQ1a3Y6CBs643iE1aaok1jxHmA1ZinPiHvKv86KwRyz7PmWKqSFcRo' }
}

file { "/etc/my.cnf":
    require => mysql,
	source => "file:///repos/server/conf/my.cnf"
}

##########
#misc
##########
package {"curl":
    ensure => present,
}

##########
#bespectacled
##########

#file { "/root/.ssh/id_rsa":
#	source => "file:///repos/server/conf/id_rsa",
#}
#
#file { "/root/.ssh/config":
#	source => "file:///repos/server/conf/config",
#}
#
#vcsrepo { "/www/bespectacled":
#	ensure   => latest,
#	owner    => $owner,
#	group    => $owner,
#	provider => git,
#	require  => [ Package["git"] ],
#	source   => "ssh://github.com/xiankai/bespectacled.git",
#	revision => 'master',
#}

##########
#phpmyadmin
##########

vcsrepo { "/www/phpmyadmin":
	ensure   => latest,
	owner    => $owner,
	group    => $owner,
	provider => git,
	require  => [ Package["git"] ],
	source   => "https://github.com/phpmyadmin/phpmyadmin.git",
	revision => 'master',
}

file { "/www/phpmyadmin/config.inc.php":
	require => [ vcsrepo["/www/phpmyadmin"] ],
	source => "file:///www/phpmyadmin/config.sample.inc.php",
}

##########
#phpmyadmin
##########

vcsrepo { "/www/wordpress":
	ensure   => latest,
	owner    => $owner,
	group    => $owner,
	provider => git,
	require  => [ Package["git"] ],
	source   => "https://github.com/WordPress/WordPress.git",
	revision => 'master',
}