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
	package {"php54w-fpm":
	  ensure => present
	}

	package {"php54w-mysql":
	  ensure => present
	}

	package {"php54w-cli":
	  ensure => present
	}

	package {"php54w-mbstring":
	  ensure => present
	}

	package {"php54w-mcrypt":
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

	#http://serverfault.com/questions/70634/what-permissions-ownership-to-set-on-php-sessions-folder-when-running-fastcgi
	file { "/var/lib/php/session":
		owner	=> 'nobody',
	}
}

class php {
	require php::config

	service { "php54w-fpm": 
		enable => true, 
		ensure => "running"
	}
}

##########
# chroot
##########

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

##########
# git
##########

class git {
	user { "git":
		ensure	=> present,
		shell	=> '/bin/git-shell',
	}
	
	file { "/home/git":
		ensure	=> directory
	}
	~>
	file { "/home/git/.ssh":
		ensure	=> directory
	}
	~>
	file { "/home/git/.ssh/id_rsa":
		ensure	=> file,
		source	=> 'file:///repos/server/files/id_rsa'
	}
}

##########
# and off we go
##########
include php, nginx, git