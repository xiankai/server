############
#Setup repos
############
yumrepo { "nginx":
	name => "nginx_repo",
	baseurl => "http://nginx.org/packages/centos/6/\$basearch/",
	gpgcheck => 0,
	enabled => 1
}

yumrepo { "epel":
	name => "epel6_repo",
	baseurl => "http://download.fedoraproject.org/pub/epel/6/\$basearch",
	mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&amp;arch=\$basearch",
	gpgcheck => 0,
	enabled => 1
}

exec { "/usr/bin/puppet module install puppetlabs/vcsrepo": }

exec { "/usr/bin/puppet module install puppetlabs/mysql": }