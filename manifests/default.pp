# Basic Packages
$packages = [
    "vim-common",
    "vim-minimal",
    "vim-enhanced",
    "make",
    "git"
]
package { $packages:
    ensure => installed,
}


# EPEL Packages
yumrepo { "epel":
    mirrorlist => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${::operatingsystemmajrelease}&arch=${::architecture}",
    baseurl => 'absent',
    failovermethod => 'priority',
    enabled => '1',
    gpgcheck => '1',
    gpgkey => 'https://fedoraproject.org/static/0608B895.txt'
}

# Custom Modules

include bounce
