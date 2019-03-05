# Sets up chkrootkit to be run once per week with results sent to syslog by
# default.
#
# @param minute   Cron minute
# @param hour     Cron hour
# @param monthday Cron monthday
# @param month    Cron month
# @param weekday  Cron weekday
#
# @param syslog
#   Enable syslog log forwarding
#
# @param log_dest
#   Set to local6.notice, any other syslog destination to forward to syslog.
#   Worthless if $syslog is false.
#
# @param package_ensure The ensure status of packages to be managed
#
# @author https://github.com/simp/pupmod-simp-chkrootkit/graphs/contributors
#
class chkrootkit (
  String  $log_dest = 'local6.notice',
  String  $minute   = '0',
  String  $hour     = '0',
  String  $monthday = '*',
  String  $month    = '*',
  String  $weekday  = '0',
  Boolean $syslog   = simplib::lookup('simp_options::syslog', { 'default_value' => false }),
  String  $package_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
) {

  if $syslog {
    $_command = "/usr/sbin/chkrootkit -n | /bin/logger -p ${log_dest} -t chkrootkit"
  }
  else {
    $_command = '/usr/sbin/chkrootkit -n'
  }

  package { 'chkrootkit':
    ensure => $package_ensure
  }

  cron { 'chkrootkit':
    command  => $_command,
    minute   => $minute,
    hour     => $hour,
    month    => $month,
    monthday => $monthday,
    weekday  => $weekday,
    require  => Package['chkrootkit']
  }

}
