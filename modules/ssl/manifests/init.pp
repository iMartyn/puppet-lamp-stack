class ssl {
    file { '/etc/ssl':
        ensure => 'directory',
    }
    file { '/etc/ssl/mycerts':
        ensure => 'directory',
        mode => 770,
        owner => 'root',
        group => 'www-data'
    }
    file { '/etc/ssl/private':
        ensure => 'directory',
        mode => 710,
        owner => 'root',
        group => 'ssl-cert'
    }
    $mailhostname = hiera('mailhostname')
    $cloudhostname = hiera('cloudhostname')
    $pfahostname = hiera('pfahostname')
    user { 'letsencrypt':
	ensure => 'present',
	groups => 'www-data'
    }
    file { '/home/letsencrypt':
        ensure => 'directory',
        mode => 700,
        owner => 'letsencrypt',
        group => 'www-data'
    }
    file { '/home/letsencrypt/data':
        ensure => 'directory',
        mode => 700,
        owner => 'letsencrypt',
        group => 'www-data'
    }
    exec { 'git-clone-acme-tiny':
        command => 'git clone https://github.com/diafygi/acme-tiny.git',
        path => '/home/letsencrypt',
        user => 'letsencrypt',
        creates => '/home/letsencrypt/acme-tiny',
}
