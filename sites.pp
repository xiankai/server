##########
#filetransfer
##########

group { "filetransfer":
	ensure 	=> present,
}

file { "/etc/ssh/sshd_config":
	source	=> "file:///repos/server/conf/sshd_config",
	mode	=> 600,
	notify	=> Service['sshd'],
}

##########
#bespectacled
##########

#vcsrepo { "/www/bespectacled":
#	ensure   => latest,
#	owner    => $owner,
#	group    => $owner,
#	provider => git,
#	source   => "ssh://github.com/xiankai/bespectacled.git",
#	revision => 'master',
#}
#
#file { "/etc/nginx/conf.d/bespectacled.conf":
#	source =>   "file:///repos/server/conf/bespectacled.conf",
#	notify => Service["nginx"],
#	require => Package['nginx'],
#	mode   => 644,
#}

##########
#phpmyadmin
##########

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

file { "/etc/nginx/conf.d/phpmyadmin.conf":
	source =>   "file:///repos/server/conf/phpmyadmin.conf",
	notify => Service["nginx"],
	require => Package['nginx'],
	mode   => 644,
}

##########
#wordpress
##########

user { "wordpress":
	ensure	=> present,
	groups	=> wordpress,
	password	=> wordpress,
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

file { "/etc/nginx/conf.d/wordpress.conf":
	source	=>   "file:///repos/server/conf/wordpress.conf",
	notify	=> Service["nginx"],
	require	=> Package['nginx'],
	mode	=> 644,
}

##########
#deanishes
##########

user { "deanishes":
	require	=> Group['filetranfer'],
	ensure	=> present,
	groups	=> wordpress,
	shell	=> /sbin/nologin,
	password	=> deanishes,
}

file { "/www/deanishes":
	ensure 	=> directory,
	source	=> "file:///www/wordpress",
	recurse	=> true,
	require => [ Vcsrepo['/www/wordpress'], User['deanishes'], Group['filetransfer'] ],
	owner	=> deanishes,
	group	=> filetransfer,
}

file { "/etc/nginx/conf.d/deanishes.conf":
	source =>   "file:///repos/server/conf/deanishes.conf",
	notify => Service["nginx"],
	require => Package['nginx'],
	mode   => 644,
}