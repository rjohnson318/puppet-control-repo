# Install and configure the useradd default configuration file.
# See useradd(8) for more details.
#
# @param group
# @param home
# @param inactive
# @param expire
# @param shell
# @param skel
# @param create_mail_spool
#
# author: SIMP Team <simp@simp-project.com>
#
class useradd::useradd (
  Integer              $group             = 100,
  Stdlib::AbsolutePath $home              = '/home',
  Integer              $inactive          = 35,
  Optional[String]     $expire            = undef,
  Stdlib::AbsolutePath $shell             = '/bin/bash',
  Stdlib::AbsolutePath $skel              = '/etc/skel',
  Boolean              $create_mail_spool = true,
) {
  if !empty($expire) { validate_re($expire,'^\d{4}-\d{2}-\d{2}$') }

  file { '/etc/default/useradd':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('useradd/etc/default/useradd.erb')
  }
}

