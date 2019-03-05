# puppet-timezone [![Build Status](https://secure.travis-ci.org/saz/puppet-timezone.png)](http://travis-ci.org/saz/puppet-timezone)

----
>
> THIS IS A FORK OF THE MODULE AND WILL REVERT TO THE ORIGINAL MODULE ONCE THE
> SIMP PACKAGING SYSTEM HAS BEEN UPDATED.
>
> The fork includes the following minor changes that are related to publishing
> and maintenance:
>   - .travis.yml       => Modified to work with the SIMP publishing process
>   - CHANGELOG         => Added to work with the SIMP RPM building
>   - README.md         => These modifications
>   - Rakefile          => Modified with the standard SIMP rake tasks
>   - metadata.json     => Modified namespace and Puppet 5 support
>   - tests/init.pp     => Removed per modern Puppet best practice
>   - manifests/init.pp => updated with latest fixes and added a require statement
>                          for /etc/localtime when running timezone update to ensure
>                          /etc/localtime is a link.
>   - spec/support/*    => tests for the changes in manifests/init.pp
>
> New modifications are copyright Onyx Point, Inc.
>
----

Manage timezone settings via Puppet

### Supported Puppet versions
* Puppet >= 4
* Last version supporting Puppet 3: v3.5.0

## Usage

### Set timezone to UTC
```
    class { 'timezone':
        timezone => 'UTC',
    }
```

### Set timezone to Europe/Berlin
```
    class { 'timezone':
        timezone => 'Europe/Berlin',
    }
```

## Other class parameters
* ensure: present or absent, default: present
* autoupgrade: true or false, default: false. Auto-upgrade package, if there is a newer version
* hwutc: true or false, default: undef. This parameter will ensure that the real time clock is set to UTC rather than the local timezone. This is not supported on all platforms and will fail if you try and set it on an unsupported platform. A typical error message from the ```timedatectl``` command, if this value is set to false would be:
```
Warning: The system is configured to read the RTC time in the local time zone.
         This mode can not be fully supported. It will create various problems
         with time zone changes and daylight saving time adjustments. The RTC
         time is never updated, it relies on external facilities to maintain it.
         If at all possible, use RTC in UTC by calling
         'timedatectl set-local-rtc 0'.
```
