class bounce {

  # Ensure Node and npm are installed via puppetlabs/nodejs (https://forge.puppetlabs.com/puppetlabs/nodejs)
    require nodejs

  # Install forever (https://www.npmjs.org/package/forever)
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
        home => '/home/bounce',
        managehome => true,
        comment => 'Service user for Bounce',
        password => '$1$hvI2Oipv$xWT8ePfKSXbsptZd3EMgE.'
    }
}
