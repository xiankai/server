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
	baseurl => "http://repo.webtatic.com/yum/el6/\$basearch/",
	mirrorlist => "http://mirror.webtatic.com/yum/el6/\$basearch/mirrorlist",
	gpgcheck => 0,
	enabled => 1
}

#hiera
file { "/etc/hiera.yaml":
	ensure => link,
	target => "/repos/server/hiera.yaml",
}

#setup hiera for puppet
file { "/etc/puppet/hiera.yaml":
	ensure => link,
	target => "/repos/server/hiera.yaml",
}

define puppet_module {
	$vars = split($name, '/')
	exec { "/usr/bin/puppet module install ${name}":
		creates => "/etc/puppet/modules/${vars[1]}/manifests/init.pp",
	}
}

puppet_module { [
	"puppetlabs/mysql",
	"puppetlabs/vcsrepo",
	"AlexCline/dirtree",
	"garethr/hiera_etcd",
]: }