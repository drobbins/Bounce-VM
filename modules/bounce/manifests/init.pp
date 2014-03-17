class bounce {

    $bounce_user = "bounce"
    $bounce_user_home = "/home/bounce"
    $bounce_home = "${bounce_user_home}/bounce"

  # Ensure Node and npm are installed via puppetlabs/nodejs (https://forge.puppetlabs.com/puppetlabs/nodejs)
    case $::operatingsystem {
        'Fedora', 'RedHat', 'Scientific', 'CentOS', 'OEL', 'OracleLinux', 'Amazon': {
            # Load EPEL Repo for access to NodeJS package
            yumrepo { "epel":
                mirrorlist     => "http://mirrors.fedoraproject.org/mirrorlist?repo=epel-${::operatingsystemmajrelease}&arch=${::architecture}",
                baseurl        => 'absent',
                failovermethod => 'priority',
                enabled        => '1',
                gpgcheck       => '1',
                gpgkey         => 'https://fedoraproject.org/static/0608B895.txt'
            }
        }
        default: {
        }
    }
    class { 'nodejs': }

  # Ensure forever (https://www.npmjs.org/package/forever) is installed
    package { 'forever':
        ensure   => installed,
        provider => 'npm',
        require  => Class['nodejs']
    }

  # Ensure MongoDB is installed
    class {'::mongodb::globals':
      manage_package_repo => true,
    } ->
    class {'::mongodb::server': } ->
    class {'::mongodb::client': }

  # User for to own the Bounce service
    group { 'services':
        ensure => present
    }
    user { $bounce_user:
        ensure     => 'present',
        name       => $bounce_user,
        uid        => '701',
        gid        => 'services',
        home       => $bounce_user_home,
        managehome => true,
        comment    => 'Service user for Bounce',
        password   => '$1$hvI2Oipv$xWT8ePfKSXbsptZd3EMgE.'
    }

  # Ensure Bounce repository is cloned into the bounce users home directory
    vcsrepo { $bounce_home:
        ensure   => present,
        provider => git,
        source   => 'https://github.com/agrueneberg/Bounce.git',
        require  => User[$bounce_user],
        user     => $bounce_user
    }

  # Ensure the NPM dependencies are installed
    exec { 'bounce-npm-install':
        command     => 'npm install',
        cwd         => $bounce_home,
        path        => '/usr/local/bin:/usr/bin:/bin',
        require     => [Vcsrepo[$bounce_home], Class['nodejs']],
        environment => ["HOME=${bounce_user_home}"],
        user        => $bounce_user
    }

  # Ensure Bounce is running
    file { "${bounce_user_home}/.forever":
        ensure    => absent,
        subscribe => [Exec['bounce-npm-install'], Package['forever'], Class['::mongodb::server']],
        force     => true
    }
    exec { 'bounce':
        command     => "forever start --pidFile bounce.pid bin/bounce.js",
        cwd         => $bounce_home,
        path        => '/usr/local/bin:/usr/bin:/bin',
        subscribe   => File["${bounce_user_home}/.forever"],
        user        => $bounce_user,
        environment => ["HOME=${bounce_user_home}"],
        creates     => "${bounce_user_home}/.forever/pids/bounce.pid"
    }

  # Ensure the Firewall is configured to allow Bounce traffic
    firewall { '100 allow Bounce http(s) traffic':
        port   => [27080, 27081],
        proto  => tcp,
        action => accept
    }

  # Set up NGINX proxy for SSL
    include nginx
    nginx::resource::vhost { 'localhost':
        ensure   => present,
        proxy    => 'http://localhost:27080',
        ssl      => true,
        ssl_cert => '/vagrant/modules/bounce/files/ssl/server.crt',
        ssl_key  => '/vagrant/modules/bounce/files/ssl/server.key',
        ssl_port => 27081
    }
}
