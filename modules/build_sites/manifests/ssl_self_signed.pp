class build_sites::ssl_self_signed {
  file {
    '/etc/pki/tls/certs/self_signed.crt':
      ensure    => file,
      source    => 'puppet:///modules/build_sites/ssl/self_signed.crt';
    '/etc/pki/tls/private/self_signed.key':
      ensure    => file,
      source    => 'puppet:///modules/build_sites/ssl/self_signed.key',
  }
}