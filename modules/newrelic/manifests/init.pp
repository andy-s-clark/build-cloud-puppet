class newrelic {
  # require user::tomcat

  file { '/opt/newrelic':
    ensure  => directory,
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => 0644,
  }
}