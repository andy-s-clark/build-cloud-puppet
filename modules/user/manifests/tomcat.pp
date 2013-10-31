# This is the Wolseley SiteScope monitoring user
class user::tomcat inherits user::virtual {
    realize(
      User['tomcat'],
      Group['tomcat'],
    )
    file { '/home/tomcat':
      ensure => 'directory',
      owner  => 'tomcat',
      group  => 'tomcat',
    }
}
