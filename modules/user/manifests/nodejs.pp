class user::nodejs inherits user::virtual {
    realize(
      User['nodejs'],
      Group['nodejs'],
    )
    file { '/home/nodejs':
      ensure => 'directory',
      owner  => 'nodejs',
      group  => 'nodejs',
    }
}
