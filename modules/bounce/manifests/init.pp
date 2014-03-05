class bounce {

    $bounce_user_home = "/home/bounce"
    $bounce_home = "${bounce_user_home}/bounce"

  # Ensure Node and npm are installed via puppetlabs/nodejs (https://forge.puppetlabs.com/puppetlabs/nodejs)
    require nodejs

  # Ensure forever (https://www.npmjs.org/package/forever) is installed
    package { 'forever':
        ensure => installed,
        provider => 'npm'
    }

  # Ensure MongoDB is installed
    require mongodb::server
    require mongodb::client

  # User for to own the Bounce service
    group { 'services':
        ensure => present
    }
    user { 'bounce':
        ensure => 'present',
        name => 'bounce',
        uid => '701',
        gid => 'services',
        home => $bounce_user_home,
        managehome => true,
        comment => 'Service user for Bounce',
        password => '$1$hvI2Oipv$xWT8ePfKSXbsptZd3EMgE.'
    }

  # Ensure Bounce repository is cloned into the bounce users home directory
    vcsrepo { $bounce_home:
        ensure => present,
        provider => git,
        source => 'https://github.com/agrueneberg/Bounce.git',
        require => User['bounce']
    }

  # Ensure the NPM dependencies are installed
    exec { 'bounce-npm-install':
        command     => 'npm install',
        cwd         => $bounce_home,
        path        => '/usr/local/bin:/usr/bin:/bin',
        require     => Vcsrepo[$bounce_home],
        environment => ["HOME=${bounce_user_home}"]
    }
}
