class bounce {

  # Ensure Node and npm are installed via puppetlabs/nodejs (https://forge.puppetlabs.com/puppetlabs/nodejs)
    require nodejs

  # Install forever (https://www.npmjs.org/package/forever)
    package { 'forever':
        ensure => installed,
        provider => 'npm'
    }
}
