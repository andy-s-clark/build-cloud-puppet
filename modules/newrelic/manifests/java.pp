class newrelic::java($app_name='undef') {
  include newrelic

  $java_agent = hiera_hash('newrelic::java_agent')
  file {'/opt/newrelic/newrelic.jar':
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => 0664,
    source  => 'puppet:///modules/newrelic/newrelic.jar',
    require => File['/opt/newrelic'],
  }
  file {'/opt/newrelic/newrelic.yml':
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => 0660,
    content => template('newrelic/newrelic.yml.erb'),
    require => File['/opt/newrelic'],
  }
}