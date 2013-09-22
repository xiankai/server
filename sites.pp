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
}

define wordpress ($domain = '', $owner) {
	file { "/www/$owner/$title":
		ensure 	=> directory,
		recurse	=> true,
		require => [ Ftp_user[$owner] ],
		owner	=> $owner,
		group	=> filetransfer,
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
	pass => '',
}

#vcsrepo { "/www/bespectacled":
#	ensure   => latest,
#	owner    => $owner,
#	group    => $owner,
#	provider => git,
#	source   => "ssh://github.com/xiankai/bespectacled.git",
#	revision => 'master',
#}
#
#website { 'bespectacled':
#	owner => 'kj',
#}

vcsrepo { "/www/phpmyadmin":
	ensure   => latest,
	owner    => $owner,
	group    => $owner,
	provider => git,
	source   => "https://github.com/phpmyadmin/phpmyadmin.git",
	revision => 'master',
}

file { "/www/phpmyadmin/config.inc.php":
	require => [ Vcsrepo["/www/phpmyadmin"] ],
	source => "file:///www/phpmyadmin/config.sample.inc.php",
}

website { 'phpmyadmin':
	owner => 'kj',
}

ftp_user { "wordpress":
	pass	=> 'qgfh.4ssHCQHs',
}

vcsrepo { "/www/wordpress":
	require	=> [ User['wordpress'], Group['filetransfer'] ],
	ensure	=> latest,
	owner	=> wordpress,
	group	=> filetransfer,
	source 	=> "https://github.com/WordPress/WordPress.git",
	provider	=> git,
	revision	=> 'master',
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