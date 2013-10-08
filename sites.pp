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
		require	=> [ User[$title], Group['filetransfer'] ],
	}
}

define wordpress ($domain = '', $owner) {
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
		content	=> template("/repos/server/conf/wordpress.erb"),
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
		content	=> template("/repos/server/conf/www.erb"),
		notify	=> Service['nginx'],
		mode	=> 644,
	}
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

vcsrepo { "/www/kj/laravel":
	ensure   => latest,
	owner    => $owner,
	group    => $owner,
	provider => git,
	source   => "https://github.com/xiankai/Laravel.git",
	revision => 'master',
}

vcsrepo { "/www/kj/phpmyadmin":
	ensure   => latest,
	owner    => $owner,
	group    => $owner,
	provider => git,
	source   => "https://github.com/phpmyadmin/phpmyadmin.git",
	revision => 'RELEASE_4_0_7',
}

file { "/www/kj/phpmyadmin/config.inc.php":
	ensure   => present,
	require => [ Vcsrepo["/www/kj/phpmyadmin"] ],
	source => "file:///repos/server/conf/config.inc.php",
}

class sites {
	$ftp_users = hiera('ftp_user', [])
	create_resources('ftp_user', $ftp_users)
	
	$wordpress = hiera('wordpress', [])
	create_resources('wordpress', $wordpress)
	
	$websites = hiera('website', [])
	create_resources('website', $websites)
}

class { 'sites': }