##########
# defined types
##########

define ftp_user ($pass) {
	user { "$title":
		ensure	=> present,
		groups	=> filetransfer,
		require	=> [ Group['filetransfer'] ],
		shell	=> '/usr/bin/rssh',
		password	=> $pass,
		home	=> '/www/$title'
	}
	
	file { "/www/$title":
		ensure	=> directory,
		owner	=> root,
		group	=> root,
		require	=> [ User[$title] ],
	}
	
	file { "/www/$title/logs":
		ensure	=> directory,
	}
}

define wordpress ($domain = '', $owner) {
	file { "/www/$owner/$title":
		ensure 	=> directory
	}
	
	file { "/www/$owner/logs/$title-access.log":
		ensure	=> present
	}
	
	file { "/www/$owner/logs/$title-error.log":
		ensure	=> present
	}

	file { "/etc/nginx/conf.d/$title.conf":
		content	=> template("/repos/server/templates/wordpress.erb"),
		notify	=> Service['nginx'],
		mode	=> 644,
	}
}

define website ($domain = '', $path = $title, $owner) {
	file { "/www/$owner/$title":
		ensure 	=> directory,
		recurse	=> true,
		require => [ Ftp_user[$owner] ],
		owner	=> $owner,
		group	=> filetransfer,
	}
	
	file { "/www/$owner/logs/$title-access.log":
		ensure	=> present
	}
	
	file { "/www/$owner/logs/$title-error.log":
		ensure	=> present
	}

	file { "/etc/nginx/conf.d/$title.conf":
		content	=> template("/repos/server/templates/www.erb"),
		notify	=> Service['nginx'],
		mode	=> 644,
	}
}

define permissions ($owner, $domain = '', $path = '') {
	exec { "/bin/chmod 755 -R /www/$owner/$name": }
}

##########
# services
##########

service { 'sshd':
	ensure => 'running',
}

service { 'nginx':
	ensure => 'running',
}

##########
#filetransfer
##########

group { "filetransfer":
	ensure 	=> present,
}

##########
# 
##########

# vcsrepo { "/www/kj/laravel":
# 	ensure   => present,
# 	provider => git,
# 	source   => "https://github.com/xiankai/Laravel.git",
# 	revision => 'master',
# }

# vcsrepo { "/www/kj/phpmyadmin":
# 	ensure   => present,
# 	provider => git,
# 	source   => "https://github.com/phpmyadmin/phpmyadmin.git",
# 	revision => 'RELEASE_4_0_7',
# }

# vcsrepo { "/www/kj/wordpress":
# 	ensure   => present,
# 	provider => git,
# 	source   => "https://github.com/wordpress/wordpress",
# 	revision => '3.6.1',
# }

file { "/www/kj/phpmyadmin/config.inc.php":
	ensure   => present,
	# require => [ Vcsrepo["/www/kj/phpmyadmin"] ],
	source => "file:///repos/server/files/config.inc.php",
}

file { "/www/kj/laravel/app/storage":
	ensure	=> directory,
	# require	=> [ Vcsrepo["/www/kj/laravel"] ],
	mode	=> 777,
	recurse => true,
}

class sites {
	$ftp_users = hiera('ftp_user', [])
	create_resources('ftp_user', $ftp_users)
	
	$wordpress = hiera('wordpress', [])
	create_resources('wordpress', $wordpress)
	
	$websites = hiera('website', [])
	create_resources('website', $websites)
}

class setup_sites {
	contain sites

	#base dir first
	file { '/www':
		ensure => directory,
		before => Class['sites'],
	}

	#permissions after sites
	$defaults = {
		require => [ File['/www'], Class['sites'] ],
	}
	
	$wordpress = hiera('wordpress')
	create_resources('permissions', $wordpress, $defaults)
	
	$websites = hiera('website')
	create_resources('permissions', $websites, $defaults)
}

class { "setup_sites": }