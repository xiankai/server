############
# nginx
############

class nginx::core {
	package { "nginx":
		ensure	=> present
	}
}

class nginx::config {
	require nginx::core

	file { "/etc/nginx/nginx.conf":
	  source =>   "file:///repos/server/files/nginx.conf",
	  mode   => 644
	}

	file { "/etc/nginx/conf.d/default.conf":
	  source =>   "file:///repos/server/files/default.conf",
	  mode   => 644
	}
}

class nginx {
	require nginx::config

	service { "nginx": 
		enable => true, 
		ensure => running,
	}
}

##########
# php
##########

class php::core {
	package {"php55w-fpm":
	  ensure => present
	}

	package {"php55w-mysql":
	  ensure => present
	}

	package {"php55w-cli":
	  ensure => present
	}

	package {"php55w-mbstring":
	  ensure => present
	}

	package {"php55w-mcrypt":
	  ensure => present
	}
}

class php::config {
	require php::core

	file { "/etc/php.ini":
	  source =>   "file:///repos/server/files/php.ini",
	  mode   => 644
	}

	file { "/etc/php-fpm.d/www.conf":
	  source =>   "file:///repos/server/files/www.conf",
	  mode   => 644
	}

	file { "/var/lib/php/session":
		owner	=> 'nginx',
		mode 	=> 700,
	}
}

class php {
	require php::config

	service { "php-fpm": 
		enable => true, 
		ensure => "running"
	}
}

##########
# chroot
##########

class chroot {
	service { 'sshd':
		ensure => 'running',
	}

	file { "/etc/ssh/sshd_config":
		source	=> "file:///repos/server/files/sshd_config",
		mode	=> 600,
		notify	=> Service['sshd'],
	}

	package { 'rssh':
		ensure	=> present,
	}

	file {	'/etc/rssh.conf':
		ensure	=> present,
		content	=> 'allowsftp'
	}
}

##########
# and off we go
##########
include php, nginx, chroot, mysql::server