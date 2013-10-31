# Fully sponsored accounts of interest as virtual resources
# Fully sponsored groups of interest as virtual resources
class user::virtual {
  @user {
    'tomcat':
      ensure  => 'present',
      uid     => '91',
      gid     => '91',
      comment => 'Apache Tomcat',
      home    => '/home/tomcat',
      shell   => '/bin/bash',
      groups  => ['tape'];
    'nodejs':
      ensure  => 'present',
      uid     => '92',
      gid     => '92',
      comment => 'NodeJS',
      home    => '/home/nodejs',
      shell   => '/bin/bash',
      groups  => ['nodejs'],
  }

  # Begin Groups
  @group {
    'tomcat':
      ensure  => 'present',
      gid   => '91';
    'nodejs':
      ensure  => 'present',
      gid   => '92',
  }
}
