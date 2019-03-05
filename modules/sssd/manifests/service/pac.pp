# This class sets up the [pac] section of /etc/sssd.conf.
#
# The class parameters map directly to SSSD configuration.  Full
# documentation of these configuration options can be found in the
# sssd.conf(5) man page.
#
# @param description
# @param debug_level
# @param debug_timestamps
# @param debug_microseconds
# @param allowed_uids
#
# @author https://github.com/simp/pupmod-simp-sssd/graphs/contributors
#
class sssd::service::pac (
  Optional[String]             $description        = undef,
  Optional[Sssd::DebugLevel]   $debug_level        = undef,
  Boolean                      $debug_timestamps   = true,
  Boolean                      $debug_microseconds = false,
  Array[String]                $allowed_uids       = []
) {
  include '::sssd'

  concat::fragment { 'sssd_pac.service':
    target  => '/etc/sssd/sssd.conf',
    content => template("${module_name}/service/pac.erb"),
    order   => '30'
  }
}
