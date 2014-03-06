class bounce {

    $bounce_user = "bounce"
    $bounce_user_home = "/home/bounce"
    $bounce_home = "${bounce_user_home}/bounce"

  # Ensure Node and npm are installed via puppetlabs/nodejs (https://forge.puppetlabs.com/puppetlabs/nodejs)
    class { 'nodejs':
        manage_repo => true
    }

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
    file { "${bounce_home}/out":
        ensure => directory,
        owner  => $bounce_user
    }
    exec { 'bounce':
        command     => 'forever start --pidFile bounce.js bin/bounce.js',
        cwd         => $bounce_home,
        path        => '/usr/local/bin:/usr/bin:/bin',
        require     => [Exec['bounce-npm-install'], Package['forever'], Class['::mongodb::server']],
        user        => $bounce_user,
        environment => ["HOME=${bounce_user_home}"],
        creates     => "${bounce_user_home}/.forever/pids/bounce.js"
    }
}
