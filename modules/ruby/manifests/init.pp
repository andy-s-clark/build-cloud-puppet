# Extremly simple class. Puppetlabs version kept trying to update itself rather than using the version from Yum.
class ruby {
  package {'ruby':
  }
}