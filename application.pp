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
#misc
##########
package {"curl":
    ensure => present,
}