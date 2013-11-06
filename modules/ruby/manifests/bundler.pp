class ruby::bundler {
  require ruby

  exec { 'bundler_install':
    command     => '/usr/bin/gem install bundler',
    creates     => '/usr/bin/bundle',
  }
}