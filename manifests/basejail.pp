class jail::basejail (
    $basejail_location = $jail::params::basejail_location,
    $freebsd_download_url = $jail::params::freebsd_download_url,
    $freebsd_components = $jail::params::freebsd_components,
    $freebsd_download_path = $jail::params::freebsd_download_path
) inherits jail::params {

    # Make sure the basejail location exists
    # For now we just do folder, ZFS will be added later

    file {$basejail_location:
        ensure  => directory,
        recurse => true
    }
    file {$freebsd_download_path:
        ensure  => directory,
        recurse => true
    }

    $base_download_path = "${freebsd_download_path}/base.txz"
    $base_download_url = "${freebsd_download_url}/base.txz"
    exec {'base.txz':
        creates => $base_download_path,
        command => "ftp -o ${base_download_path} ${base_download_url}",
        path    => "/usr/bin",
        require => [File[$freebsd_download_path]],
    }

    $doc_download_path = "${freebsd_download_path}/doc.txz"
    $doc_download_url = "${freebsd_download_url}/doc.txz"
    exec {'doc.txz':
        creates => $doc_download_path,
        command => "ftp -o ${doc_download_path} ${doc_download_url}",
        path    => "/usr/bin",
        require => [File[$freebsd_download_path]],
    }

    $games_download_path = "${freebsd_download_path}/games.txz"
    $games_download_url = "${freebsd_download_url}/games.txz"
    exec {'games.txz':
        creates => $games_download_path,
        command => "ftp -o ${games_download_path} ${games_download_url}",
        path    => "/usr/bin",
        require => [File[$freebsd_download_path]],
    }

    $lib32_download_path = "${freebsd_download_path}/lib32.txz"
    $lib32_download_url = "${freebsd_download_url}/lib32.txz"
    exec {'lib32.txz':
        creates => $lib32_download_path,
        command => "ftp -o ${lib32_download_path} ${lib32_download_url}",
        path    => "/usr/bin",
        require => [File[$freebsd_download_path]],
    }

    $ports_download_path = "${freebsd_download_path}/ports.txz"
    $ports_download_url = "${freebsd_download_url}/ports.txz"
    exec {'ports.txz':
        creates => $ports_download_path,
        command => "ftp -o ${ports_download_path} ${ports_download_url}",
        path    => "/usr/bin",
        require => [File[$freebsd_download_path]],
    }

}   