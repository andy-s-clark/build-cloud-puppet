class newrelic::nginx_agent {
  require newrelic
  require ruby::bundler
  include nginx

  wget::fetch { '/opt/newrelic/newrelic_nginx_agent.tar.gz':
    source        => 'http://nginx.com/download/newrelic/newrelic_nginx_agent.tar.gz',
    destination   => '/opt/newrelic/newrelic_nginx_agent.tar.gz',
    verbose       => true,
    before        => Exec['newrelic_nginx_agent_extract'],
  }

  exec {
    'newrelic_nginx_agent_extract':
      cwd         => '/opt/newrelic',
      command     => '/bin/tar xzf /opt/newrelic/newrelic_nginx_agent.tar.gz && mv /opt/newrelic/newrelic_nginx_agent /opt/newrelic/nginx_agent',
      creates     => '/opt/newrelic/nginx_agent';
    'newrelic_nginx_agent_install':
      cwd         => '/opt/newrelic/nginx_agent',
      command     => '/usr/bin/bundle ',
      creates     => '/opt/newrelic/nginx_agent/config/newrelic_plugin.yml', # Doesn't really create this, puppet does
      require     => [ Exec['newrelic_nginx_agent_extract'], Class['ruby::bundler'] ],
  }

  $nginx_agent = hiera_hash('newrelic::nginx_agent')
  file {
    '/opt/newrelic/nginx_agent/config/newrelic_plugin.yml':
      owner       => 'tomcat',
      group       => 'tomcat',
      mode        => 0660,
      content     => template('newrelic/nginx_agent/newrelic_plugin.yml.erb'),
      require     => Exec['newrelic_nginx_agent_install'];
    '/etc/nginx/conf.d/stub_status.conf.erb':
      ensure      => present,
      content     => template('newrelic/nginx_agent/stub_status.conf.erb'),
      require     => Class['nginx::package'],
      notify      => Service['nginx'];
    '/etc/init/newrelic-nginx-agent.conf':
      ensure      => present,
      source      => 'puppet:///modules/newrelic/newrelic-nginx-agent.conf',
      mode        => '0644',
      owner       => 'root',
      group       => 'root',
      notify      => Service['newrelic-nginx-agent'],
      require     => Exec['newrelic_nginx_agent_install'],
  }

  service { 'newrelic-nginx-agent':
    ensure        => running,
    hasstatus     => true,
    hasrestart    => true,
    start         => '/sbin/initctl start newrelic-nginx-agent',
    restart       => '/sbin/initctl restart newrelic-nginx-agent',
    stop          => '/sbin/initctl stop newrelic-nginx-agent',
    status        => '/sbin/initctl status newrelic-nginx-agent | grep "/running" 1>/dev/null 2>&1',
    require       => File['/etc/init/newrelic-nginx-agent.conf'],
  }
}