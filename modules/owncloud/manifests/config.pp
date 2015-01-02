class owncloud::config {

    $domain = hiera('domain')
    $mysql_oc_password = hiera('mysql_oc_password')

    file { 'owncloud-config.php':
        path => '/var/www/owncloud/config/config.php',
        content => template('owncloud/config.php.erb')
    }

    exec { 'randomise-owncloud-instance':
        command => "sed s/'##INSTANCE##'/\"`pwgen -nC 12 1 | sed s/' '//g`\"/g -i /var/www/owncloud/config/config.php",
        unless => "grep instanceid /var/www/owncloud/config/config.php | grep INSTANCE",
        require => File['/var/www/owncloud/config/config.php']
    }

    exec { 'randomise-owncloud-pwsalt':
        command => "sed s/'############SALT##############'/\"`pwgen -nC 30 1 | sed s/' '//g`\"/g -i /var/www/owncloud/config/config.php",
        unless => "grep 'passwordsalt' /var/www/owncloud/config/config.php | grep SALT",
        require => File['/var/www/owncloud/config/config.php']
    }

    $admin_user = hiera('admin_user')
    $admin_name = hiera('admin_name')
    $admin_password = hiera('admin_password')
    $mysql_root_password = hiera('mysql_root_password')

    file{ 'owncloud.sql':
        path => "/tmp/owncloud.sql",
        content => template("owncloud/owncloud.sql.erb"),
        require => [ Service['mysql'], Exec[set-mysql-root-password] ],
        replace => false
    }

    exec{ 'create-owncloud-db':
        unless => "mysql -uroot -p$mysql_root_password owncloud -e 'select * from oc_users' > /dev/null",
        command => "/usr/bin/mysql -u root -p$mysql_root_password mysql < /tmp/owncloud.sql && echo \"-- Removed for security\" > /tmp/owncloud.sql",
        require => [ Service['mysql'], File['owncloud.sql'], Exec[set-mysql-root-password] ]
    }

}
