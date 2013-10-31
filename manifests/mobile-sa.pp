include nginx
include redis
include user::nodejs
include redis
include build_sites::ssl_self_signed

class { 'nodejs':
  version           => 'v0.10.21',
  make_install      => false,
  with_npm          => true,
  target_dir        => '/usr/bin',
}

$build_cloud = hiera_hash('build_sites::build_cloud')
file {
  '/var/log/build-cloud':
    ensure    => file,
    owner     => 'nodejs';
  '/etc/sysconfig/build_cloud_config':
    ensure    => file,
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    notify    => Service['build-cloud'],
    content   => template('build_sites/build_cloud_config.erb');
  '/etc/init/build-cloud.conf':
    ensure    => present,
    source    => 'puppet:///modules/build_sites/build-cloud.conf',
    mode      => '0644',
    owner     => 'root',
    group     => 'root',
    notify    => Service['build-cloud'],
    require   => [ FILE['/etc/sysconfig/build_cloud_config'], FILE['/var/log/build-cloud'] ];
  '/etc/nginx/conf.d/build-cloud.conf':
    ensure      => present,
    content     => template('build_sites/nginx/build-cloud.conf.erb'),
    require     => [ Class['nginx::package'], Class['build_sites::ssl_self_signed'] ],
    notify      => Service['nginx'];
}

service { 'build-cloud':
  ensure      => running,
  hasstatus   => true,
  hasrestart  => true,
  start       => '/sbin/initctl start build-cloud',
  restart     => '/sbin/initctl restart build-cloud',
  stop        => '/sbin/initctl stop build-cloud',
  status      => '/sbin/initctl status build-cloud | grep "/running" 1>/dev/null 2>&1',
  require     => File['/etc/init/build-cloud.conf'],
}
