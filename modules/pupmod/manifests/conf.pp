# This is a simple define to call the Puppet INIFile class for the passed
# parameters on the puppet.conf file.
#
# The main purpose is to easily allow for a service trigger.
#
# @param name
#   A globally unique name for this resource. Will be prefixed with $modname
#
# @param setting
#   The setting in the section to set
#
# @param value
#   The value of the setting to be set.
#
# @param confdir
#   The configuration directory holding the 'puppet.conf' file.
#
# @param section
#   The Sections of the puppet.conf to set.
#
# @param ensure
#  Determines whether the specified setting should exist.
#
# @author https://github.com/simp/pupmod-simp-pupmod/graphs/contributors
#
define pupmod::conf (
  String $setting,
  Scalar $value,
  String $confdir,
  String $section = 'main',
  Enum['present', 'absent'] $ensure = 'present',
) {

  $l_name = "${module_name}_${name}"

  ini_setting { $l_name:
    ensure  => $ensure,
    path    => "${confdir}/puppet.conf",
    section => $section,
    setting => $setting,
    # This needs to be a string to take effect!
    value   => $value
  }
}
