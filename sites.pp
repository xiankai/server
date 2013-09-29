##########
#classes
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
		recurse	=> true,
		owner	=> root,
		group	=> root,
		require	=> [ User[$title] ],
	}
	
	file { "/www/$title/logs":
		ensure	=> directory,
		recurse	=> true,
		owner	=> $title,
		group	=> filetransfer,
		mode	=> 644,
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
		ensure	=> present,
		owner	=> $owner,
		group	=> filetransfer,
		mode	=> 644,
	}
	
	file { "/www/$owner/logs/$title-error.log":
		ensure	=> present,
		owner	=> $owner,
		group	=> filetransfer,
		mode	=> 644,
	}

	file { "/etc/nginx/conf.d/$title.conf":
		content	=> template("/repos/server/conf/wordpress.erb"),
		notify	=> Service['nginx'],
		mode	=> 644,
	}
}

define website ($domain = '', $owner) {
	file { "/www/$owner/$title":
		ensure 	=> directory,
		recurse	=> true,
		require => [ Ftp_user[$owner] ],
		owner	=> $owner,
		group	=> filetransfer,
	}
	
	file { "/www/$owner/logs/$title-access.log":
		ensure	=> present,
		owner	=> $owner,
		group	=> filetransfer,
		mode	=> 644,
	}
	
	file { "/www/$owner/logs/$title-error.log":
		ensure	=> present,
		owner	=> $owner,
		group	=> filetransfer,
		mode	=> 644,
	}

	file { "/etc/nginx/conf.d/$title.conf":
		content	=> template("/repos/server/conf/www.erb"),
		notify	=> Service['nginx'],
		mode	=> 644,
	}
}

##########
#required
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
#kj
##########

ftp_user { 'kj':
	pass => 'ZzhAUccUZ4u5A',
}

#vcsrepo { "/www/bespectacled":
#	ensure   => latest,
#	owner    => $owner,
#	group    => $owner,
#	provider => git,
#	source   => "ssh://github.com/xiankai/bespectacled.git",
#	revision => 'master',
#}

website { 'bespectacled':
	owner => 'kj',
}

website { 'phpmyadmin':
	owner => 'kj',
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

ftp_user { "wordpress":
	pass	=> 'qgfh.4ssHCQHs',
}

wordpress { 'wordpress':
	owner	=> 'kj',
}

# Dean
ftp_user { 'deanishes':
	pass	=> 'JR.R3..N0LkJc',
}

wordpress { 'deanishes':
	domain	=> 'deanishes.com',
	owner	=> 'deanishes',
}

# Yas
ftp_user { 'yasmin':
	pass	=> 'gkboZn2A0nvcI',
}

wordpress { 'portfolio':
	domain	=> 'yasminhabayeb.com',
	owner	=> 'yasmin',
}

wordpress { 'creatibia':
	domain	=> 'creatibia.com',
	owner	=> 'yasmin',
}

website { 'mybb':
	domain	=> 'forum.creatibia.com',
	owner	=> 'yasmin',
}

# Vini

ftp_user { 'vinithar':
	pass	=> 'pce6GnqAMbAN2',
}

wordpress { 'vinithar':
	owner	=> 'vinithar',
}

# Mass

ftp_user { 'mass':
	pass	=> 'ScXnMajpq3hLA',
}

# Adam

ftp_user { 'adam':
	pass	=> 'bWKTX2Q1.ZBTM',
}

website { 'adam':
	owner	=> 'adam',
}