############
#Setup repos
############
yumrepo { "nginx":
	baseurl => "http://nginx.org/packages/centos/6/$basearch/",
	gpgcheck => 0,
	enabled => 1
}

yumrepo { "epel":
	baseurl => "http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm",
	gpgcheck => 0,
	enabled => 1
}

exec { "puppet module install puppetlabs/vcsrepo": }

exec { "puppet module install puppetlabs/mysql": }