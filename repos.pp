############
#Setup repos
############
yumrepo { "nginx":
	name => "nginx",
	descr	=> "nginx",
	baseurl => "http://nginx.org/packages/centos/6/\$basearch/",
	gpgcheck => 0,
	enabled => 1
}

yumrepo { "epel":
	name => "epel6",
	descr	=> "epel6",
	baseurl => "http://download.fedoraproject.org/pub/epel/6/\$basearch",
	mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-6&amp;arch=\$basearch",
	gpgcheck => 0,
	enabled => 1
}

yumrepo { "webtatic":
	name => "webtatic",
	descr	=> "webtatic",
	baseurl => "http://repo.webtatic.com/yum/el6/$basearch/",
	mirrorlist	=> "http://mirror.webtatic.com/yum/el6/$basearch/mirrorlist",
	gpgcheck => 0,
	enabled => 1
}

exec { "/usr/bin/puppet module install puppetlabs/vcsrepo": }

exec { "/usr/bin/puppet module install puppetlabs/mysql": }