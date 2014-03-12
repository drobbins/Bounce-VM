# define: nginx::resource::vhost
#
# This definition creates a virtual host
#
# Parameters:
#   [*ensure*]              - Enables or disables the specified vhost
#     (present|absent)
#   [*listen_ip*]           - Default IP Address for NGINX to listen with this
#     vHost on. Defaults to all interfaces (*)
#   [*listen_port*]         - Default IP Port for NGINX to listen with this
#     vHost on. Defaults to TCP 80
#   [*listen_options*]      - Extra options for listen directive like
#     'default' to catchall. Undef by default.
#   [*location_allow*]      - Array: Locations to allow connections from.
#   [*location_deny*]       - Array: Locations to deny connections from.
#   [*ipv6_enable*]         - BOOL value to enable/disable IPv6 support
#     (false|true). Module will check to see if IPv6 support exists on your
#     system before enabling.
#   [*ipv6_listen_ip*]      - Default IPv6 Address for NGINX to listen with
#     this vHost on. Defaults to all interfaces (::)
#   [*ipv6_listen_port*]    - Default IPv6 Port for NGINX to listen with this
#     vHost on. Defaults to TCP 80
#   [*ipv6_listen_options*] - Extra options for listen directive like 'default'
#     to catchall. Template will allways add ipv6only=on. While issue
#     jfryman/puppet-nginx#30 is discussed, default value is 'default'.
#   [*add_header*]          - Hash: Adds headers to the HTTP response when
#     response code is equal to 200, 204, 301, 302 or 304.
#   [*index_files*]         - Default index files for NGINX to read when
#     traversing a directory
#   [*autoindex*]           - Set it on 'on' to activate autoindex directory
#     listing. Undef by default.
#   [*proxy*]               - Proxy server(s) for the root location to connect
#     to.  Accepts a single value, can be used in conjunction with
#     nginx::resource::upstream
#   [*proxy_read_timeout*]  - Override the default the proxy read timeout value
#     of 90 seconds
#   [*resolver*]            - String: Configures name servers used to resolve
#     names of upstream servers into addresses.
#   [*fastcgi*]             - location of fastcgi (host:port)
#   [*fastcgi_params*]      - optional alternative fastcgi_params file to use
#   [*fastcgi_script*]      - optional SCRIPT_FILE parameter
#   [*ssl*]                 - Indicates whether to setup SSL bindings for this
#     vhost.
#   [*ssl_cert*]            - Pre-generated SSL Certificate file to reference
#     for SSL Support. This is not generated by this module.
#   [*ssl_dhparam*]         - This directive specifies a file containing
#     Diffie-Hellman key agreement protocol cryptographic parameters, in PEM
#     format, utilized for exchanging session keys between server and client. 
#   [*ssl_key*]             - Pre-generated SSL Key file to reference for SSL
#     Support. This is not generated by this module.
#   [*ssl_port*]            - Default IP Port for NGINX to listen with this SSL
#     vHost on. Defaults to TCP 443
#   [*ssl_protocols*]       - SSL protocols enabled. Defaults to 'SSLv3 TLSv1
#     TLSv1.1 TLSv1.2'.
#   [*ssl_ciphers*]         - SSL ciphers enabled. Defaults to
#     'HIGH:!aNULL:!MD5'.
#   [*ssl_stapling*]        - Bool: Enables or disables stapling of OCSP
#     responses by the server. Defaults to false.
#   [*ssl_stapling_file*]   - String: When set, the stapled OCSP response
#     will be taken from the specified file instead of querying the OCSP
#     responder specified in the server certificate.
#   [*ssl_stapling_responder*] - String: Overrides the URL of the OCSP
#     responder specified in the Authority Information Access certificate
#     extension.
#   [*ssl_stapling_verify*] - Bool: Enables or disables verification of
#     OCSP responses by the server. Defaults to false.
#   [*ssl_trusted_cert*]    - String: Specifies a file with trusted CA
#     certificates in the PEM format used to verify client certificates and
#     OCSP responses if ssl_stapling is enabled.
#   [*spdy*]                - Toggles SPDY protocol.
#   [*server_name*]         - List of vhostnames for which this vhost will
#     respond. Default [$name].
#   [*www_root*]            - Specifies the location on disk for files to be
#     read from. Cannot be set in conjunction with $proxy
#   [*rewrite_www_to_non_www*]  - Adds a server directive and rewrite rule to
#     rewrite www.domain.com to domain.com in order to avoid duplicate
#     content (SEO);
#   [*try_files*]               - Specifies the locations for files to be
#     checked as an array. Cannot be used in conjuction with $proxy.
#   [*proxy_cache*]             - This directive sets name of zone for caching.
#     The same zone can be used in multiple places.
#   [*proxy_cache_valid*]       - This directive sets the time for caching
#     different replies.
#   [*proxy_method*]            - If defined, overrides the HTTP method of the
#     request to be passed to the backend.
#   [*proxy_set_body*]          - If defined, sets the body passed to the backend.
#   [*auth_basic*]              - This directive includes testing name and
#      password with HTTP Basic Authentication.
#   [*auth_basic_user_file*]    - This directive sets the htpasswd filename for
#     the authentication realm.
#   [*vhost_cfg_append*]        - It expects a hash with custom directives to
#     put after everything else inside vhost
#   [*vhost_cfg_prepend*]       - It expects a hash with custom directives to
#     put before everything else inside vhost
#   [*rewrite_to_https*]        - Adds a server directive and rewrite rule to
#      rewrite to ssl
#   [*include_files*]           - Adds include files to vhost
#   [*access_log*]              - Where to write access log. May add additional
#      options like log format to the end.
#   [*error_log*]               - Where to write error log. May add additional
#      options like error level to the end.
#   [*passenger_cgi_param*]     - Allows one to define additional CGI environment
#      variables to pass to the backend application
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::vhost { 'test2.local':
#    ensure   => present,
#    www_root => '/var/www/nginx-default',
#    ssl      => true,
#    ssl_cert => '/tmp/server.crt',
#    ssl_key  => '/tmp/server.pem',
#  }
define nginx::resource::vhost (
  $ensure                 = 'enable',
  $listen_ip              = '*',
  $listen_port            = '80',
  $listen_options         = undef,
  $location_allow         = [],
  $location_deny          = [],
  $ipv6_enable            = false,
  $ipv6_listen_ip         = '::',
  $ipv6_listen_port       = '80',
  $ipv6_listen_options    = 'default',
  $add_header             = undef,
  $ssl                    = false,
  $ssl_cert               = undef,
  $ssl_dhparam            = undef,
  $ssl_key                = undef,
  $ssl_port               = '443',
  $ssl_protocols          = 'SSLv3 TLSv1 TLSv1.1 TLSv1.2',
  $ssl_ciphers            = 'HIGH:!aNULL:!MD5',
  $ssl_cache              = 'shared:SSL:10m',
  $ssl_stapling           = false,
  $ssl_stapling_file      = undef,
  $ssl_stapling_responder = undef,
  $ssl_stapling_verify    = false,
  $ssl_trusted_cert       = undef,
  $spdy                   = $nginx::params::nx_spdy,
  $proxy                  = undef,
  $proxy_read_timeout     = $nginx::params::nx_proxy_read_timeout,
  $proxy_set_header       = [],
  $proxy_cache            = false,
  $proxy_cache_valid      = false,
  $proxy_method           = undef,
  $proxy_set_body         = undef,
  $resolver               = undef,
  $fastcgi                = undef,
  $fastcgi_params         = '/etc/nginx/fastcgi_params',
  $fastcgi_script         = undef,
  $index_files            = [
    'index.html',
    'index.htm',
    'index.php'],
  $autoindex              = undef,
  $server_name            = [$name],
  $www_root               = undef,
  $rewrite_www_to_non_www = false,
  $rewrite_to_https       = undef,
  $location_custom_cfg    = undef,
  $location_cfg_prepend   = undef,
  $location_cfg_append    = undef,
  $try_files              = undef,
  $auth_basic             = undef,
  $auth_basic_user_file   = undef,
  $vhost_cfg_prepend      = undef,
  $vhost_cfg_append       = undef,
  $include_files          = undef,
  $access_log             = undef,
  $error_log              = undef,
  $passenger_cgi_param    = undef,
  $use_default_location   = true,
) {

  validate_array($location_allow)
  validate_array($location_deny)
  validate_array($proxy_set_header)
  validate_array($index_files)
  validate_array($server_name)
  if ($add_header != undef) {
    validate_hash($add_header)
  }
  if ($ssl_dhparam != undef) {
    validate_string($ssl_dhparam)
  }
  if ($resolver != undef) {
    validate_string($resolver)
  }
  validate_bool($ssl_stapling)
  if ($ssl_stapling_file != undef) {
    validate_string($ssl_stapling_file)
  }
  if ($ssl_stapling_responder != undef) {
    validate_string($ssl_stapling_responder)
  }
  validate_bool($ssl_stapling_verify)
  if ($ssl_trusted_cert != undef) {
    validate_string($ssl_trusted_cert)
  }

  # Variables
  $vhost_dir = "${nginx::config::nx_conf_dir}/sites-available"
  $vhost_enable_dir = "${nginx::config::nx_conf_dir}/sites-enabled"
  $vhost_symlink_ensure = $ensure ? {
    'absent' => absent,
    default  => 'link',
  }

  $name_sanitized = regsubst($name, ' ', '_', 'G')
  $config_file = "${vhost_dir}/${name_sanitized}.conf"

  File {
    ensure => $ensure ? {
      'absent' => absent,
      default  => 'file',
    },
    notify => Class['nginx::service'],
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Add IPv6 Logic Check - Nginx service will not start if ipv6 is enabled
  # and support does not exist for it in the kernel.
  if ($ipv6_enable == true) and (!$ipaddress6) {
    warning('nginx: IPv6 support is not enabled or configured properly')
  }

  # Check to see if SSL Certificates are properly defined.
  if ($ssl == true) {
    if ($ssl_cert == undef) or ($ssl_key == undef) {
      fail('nginx: SSL certificate/key (ssl_cert/ssl_cert) and/or SSL Private must be defined and exist on the target system(s)')
    }
  }

  # This was a lot to add up in parameter list so add it down here
  # Also opted to add more logic here and keep template cleaner which
  # unfortunately means resorting to the $varname_real thing
  $access_log_real = $access_log ? {
    undef   => "${nginx::params::nx_logdir}/${name_sanitized}.access.log",
    default => $access_log,
  }
  $error_log_real = $error_log ? {
    undef   => "${nginx::params::nx_logdir}/${name_sanitized}.error.log",
    default => $error_log,
  }

  concat { $config_file:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Class['nginx::service'],
  }

  if ($ssl == true) and ($ssl_port == $listen_port) {
    $ssl_only = true
  }

  if $use_default_location == true {
    # Create the default location reference for the vHost
    nginx::resource::location {"${name_sanitized}-default":
      ensure              => $ensure,
      vhost               => $name_sanitized,
      ssl                 => $ssl,
      ssl_only            => $ssl_only,
      location            => '/',
      location_allow      => $location_allow,
      location_deny       => $location_deny,
      proxy               => $proxy,
      proxy_read_timeout  => $proxy_read_timeout,
      proxy_cache         => $proxy_cache,
      proxy_cache_valid   => $proxy_cache_valid,
      proxy_method        => $proxy_method,
      proxy_set_body      => $proxy_set_body,
      fastcgi             => $fastcgi,
      fastcgi_params      => $fastcgi_params,
      fastcgi_script      => $fastcgi_script,
      try_files           => $try_files,
      www_root            => $www_root,
      index_files         => [],
      location_custom_cfg => $location_custom_cfg,
      notify              => Class['nginx::service'],
    }
  } else {
    $root = $www_root
  }

  # Support location_cfg_prepend and location_cfg_append on default location created by vhost
  if $location_cfg_prepend {
    Nginx::Resource::Location["${name_sanitized}-default"] {
      location_cfg_prepend => $location_cfg_prepend }
  }

  if $location_cfg_append {
    Nginx::Resource::Location["${name_sanitized}-default"] {
      location_cfg_append => $location_cfg_append }
  }

  if $fastcgi != undef and !defined(File['/etc/nginx/fastcgi_params']) {
    file { '/etc/nginx/fastcgi_params':
      ensure  => present,
      mode    => '0770',
      content => template('nginx/vhost/fastcgi_params.erb'),
    }
  }

  if ($listen_port != $ssl_port) {
    concat::fragment { "${name_sanitized}-header":
      target  => $config_file,
      content => template('nginx/vhost/vhost_header.erb'),
      order   => '001',
    }
  }

  # Create a proper file close stub.
  if ($listen_port != $ssl_port) {
    concat::fragment { "${name_sanitized}-footer":
      target  => $config_file,
      content => template('nginx/vhost/vhost_footer.erb'),
      order   => '699',
    }
  }

  # Create SSL File Stubs if SSL is enabled
  if ($ssl == true) {
    # Access and error logs are named differently in ssl template
    $ssl_access_log = $access_log ? {
      undef   => "${nginx::params::nx_logdir}/ssl-${name_sanitized}.access.log",
      default => $access_log,
    }
    $ssl_error_log = $error_log ? {
      undef   => "${nginx::params::nx_logdir}/ssl-${name_sanitized}.error.log",
      default => $error_log,
    }

    concat::fragment { "${name_sanitized}-ssl-header":
      target  => $config_file,
      content => template('nginx/vhost/vhost_ssl_header.erb'),
      order   => '700',
    }
    concat::fragment { "${name_sanitized}-ssl-footer":
      target  => $config_file,
      content => template('nginx/vhost/vhost_ssl_footer.erb'),
      order   => '999',
    }

    #Generate ssl key/cert with provided file-locations
    $cert = regsubst($name,' ','_')

    # Check if the file has been defined before creating the file to
    # avoid the error when using wildcard cert on the multiple vhosts
    ensure_resource('file', "${nginx::params::nx_conf_dir}/${cert}.crt", {
      owner  => $nginx::params::nx_daemon_user,
      mode   => '0444',
      source => $ssl_cert,
    })
    ensure_resource('file', "${nginx::params::nx_conf_dir}/${cert}.key", {
      owner  => $nginx::params::nx_daemon_user,
      mode   => '0440',
      source => $ssl_key,
    })
    if ($ssl_dhparam != undef) {
      ensure_resource('file', "${nginx::params::nx_conf_dir}/${cert}.dh.pem", {
        owner  => $nginx::params::nx_daemon_user,
        mode   => '0440',
        source => $ssl_dhparam,
      })
    }
    if ($ssl_stapling_file != undef) {
      ensure_resource('file', "${nginx::params::nx_conf_dir}/${cert}.ocsp.resp", {
        owner  => $nginx::params::nx_daemon_user,
        mode   => '0440',
        source => $ssl_stapling_file,
      })
    }
    if ($ssl_trusted_cert != undef) {
      ensure_resource('file', "${nginx::params::nx_conf_dir}/${cert}.trusted.crt", {
        owner  => $nginx::params::nx_daemon_user,
        mode   => '0440',
        source => $ssl_trusted_cert,
      })
    }
  }

  file{ "${name_sanitized}.conf symlink":
    ensure  => $vhost_symlink_ensure,
    path    => "${vhost_enable_dir}/${name_sanitized}.conf",
    target  => $config_file,
    require => Concat[$config_file],
    notify  => Service['nginx'],
  }
}
