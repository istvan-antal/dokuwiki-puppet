node default {
    $maxUploadSize = 100
    $maxUploadedFileSize = 500
    $maxFileUploads = 50

    file { "${settings::modulepath}/../web/conf/users.auth.php":
        require => Exec["install_dokuwiki"],
        replace => "no",
        ensure  => "present",
        source  => "puppet:///modules/main/users.auth.php",
        mode => 'a+rw',
    }

    file { "${settings::modulepath}/../web/conf/dokuwiki.php":
        require => Exec["install_dokuwiki"],
        replace => "no",
        content  => template('main/conf_dokuwiki.php.erb'),
        mode => 'a+rw',
    }

    file { ["${settings::modulepath}/../data", "${settings::modulepath}/../web/conf"]:
        require => Exec["install_dokuwiki"],
        ensure => directory,
        recurse => true,
        mode => 'a+rw',
    }

    file { ["${settings::modulepath}/../web/data"]:
        require => Exec["install_dokuwiki"],
        ensure => absent,
        force => true,
    }

    exec { "install_dokuwiki":
        command => "${settings::modulepath}/main/install_dokuwiki.sh 2015-08-10a",
        creates => "${settings::modulepath}/../web",
        logoutput => true,
        timeout => 1800
    }

    package { ["php5-fpm", "php5-cli", "php5-curl", "php5-redis"]:
        require => Exec["install_dokuwiki"],
        ensure => "installed"
    }

    service { "php5-fpm":
        ensure => running,
        enable => true
    }

    file { "/etc/php5/fpm/pool.d/www.conf":
        require => Package["php5-fpm"],
        source  => "puppet:///modules/main/www.conf",
        notify  => Service["php5-fpm"]
    }

    file { "/etc/php5/fpm/php.ini":
        require => Package["php5-fpm"],
        content  => template('main/php.ini.erb'),
        notify  => Service["php5-fpm"]
    }

    package { "nginx": ensure => "installed" }

    service { "nginx":
        ensure => running,
        enable => true
    }

    file { "/etc/nginx/sites-available/default":
        require => Package["nginx"],
        content  => template('main/nginx.conf.erb'),
        notify  => Service["nginx"]
    }
}