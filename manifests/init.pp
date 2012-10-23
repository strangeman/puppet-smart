# == TODO
#
# Задокументировать, чьорт побери
#
class smart(
    #smartd.conf
    $devices        = ['DEVICESCAN'], 
    $dev_type       = false,                                       # -d
    $prefailure     = true,                                        # -p
    $default        = true,                                        # -a
    $sheldule       = '(S/../../(1|2|4|5|6)/01|L/../../(3|7)/01)', # -s
    $monitor_params = ['194'],                                     # -R
    $ignor_params   = false,                                       # -I
    $temperature    = false,                                       # -W
    $offline_test   = true,                                        # -o
    $attr_autosave  = true,                                        # -S
    $email          = 'root@mail.localnet',                        # -m
    $email_type     = 'diminishing',                               # -M
    #other
    $enabled        = true,
    $default_file   = '/etc/default/smartmontools',
    $default_string = 'start_smartd=',
    $conf_file      = '/etc/smartd.conf',
    $service        = 'smartmontools',
    $package        = 'smartmontools'
) {

    case $::osfamily {
        'debian': { }
        default: {
            fail("Module smart is not supported on ${operatingsystem}")
        }
    }

    #install
    package{$package:
            ensure => installed,
    }

    #configure
    if $enabled{$yesno='yes'}
    else {$yesno='no'}
    
    file {$default_file:
        content => "${default_string}${yesno}",
        owner => 'root',
        group => 'root',
        mode => '0644',
    }

    file {$conf_file:
            content => template("smart/smartd.conf.erb"),
            owner => 'root',
            group => 'root',
            mode => '0644',
    }

    service {$service:
        ensure => $enabled,
        enable => $enabled,
        hasrestart => true,
        hasstatus => true,

    }

    Package[$package]->File[$default_file]->File[$conf_file]~>Service[$service]

    #if $enabled{File[$conf_file]~>Service[$service]}
}


