class mailcatcher {

  require ::gcc

  if defined(Class['ufw']) {
    ufw::allow { "mailcatcher":
      port => 1080,
      ip => 'any',
    }
  }

  if ! defined(Package['ruby1.9.1-dev']) {
    package { 'ruby1.9.1-dev': }
  }
  if ! defined(Package['libsqlite3-dev']) {
    package { 'libsqlite3-dev': }
  }
  if ! defined(Package['i18n']) {
    package { 'i18n':
      ensure  => '0.6.11',
      provider => 'gem',
    }
  }

  package { 'mailcatcher':
    ensure  => latest,
    provider => 'gem',
    require => [
      Package['build-essential'],
      Package['i18n'],
      Package['libsqlite3-dev'],
      Package['ruby1.9.1-dev'],
    ],
  } ->
  file { '/etc/init/mailcatcher.conf':
    ensure => file,
    content => template('mailcatcher/mailcatcher.conf.erb'),
  } ->
  service { 'mailcatcher':
    ensure => running,
    enable  => true,
  }

}
