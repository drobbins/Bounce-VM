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
