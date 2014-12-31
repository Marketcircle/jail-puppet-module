define jail::download(
  $architecture = $::hardwareisa,
  $base = true,
  $doc = true,
  $games = true,
  $kernel = false,
  $lib32 = false,
  $ports = false,
  $src = false
) {
  if !defined('wget') {
    class {'wget':}
  }
  $freebsd_version = $name
  $version_url = "${jail::freebsd_download_url}/${architecture}/${architecture}/${freebsd_version}"
  $download_path = "${jail::freebsd_download_path}/${architecture}-${freebsd_version}"

  file {$download_path:
    ensure  => directory,
    require => File[$jail::freebsd_download_path]
  }

  if $base {
    wget::fetch {"download for base.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/base.txz",
      destination => "${jail::freebsd_download_path}/base.txz",
      require     => File[$download_path]
    }
  }

  if $doc {
    wget::fetch {"download for doc.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/doc.txz",
      destination => "${jail::freebsd_download_path}/doc.txz",
      require     => File[$download_path]
    }
  }

  if $games {
    wget::fetch {"download for games.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/games.txz",
      destination => "${jail::freebsd_download_path}/games.txz",
      require     => File[$download_path]
    }
  }

  if $kernel {
    wget::fetch {"download for kernel.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/kernel.txz",
      destination => "${jail::freebsd_download_path}/kernel.txz",
      require     => File[$download_path]
    }
  }

  if $lib32 {
    wget::fetch {"download for lib32.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/lib32.txz",
      destination => "${jail::freebsd_download_path}/lib32.txz",
      require     => File[$download_path]
    }
  }

  if $ports {
    wget::fetch {"download for ports.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/ports.txz",
      destination => "${jail::freebsd_download_path}/ports.txz",
      require     => File[$download_path]
    }
  }

  if $src {
    wget::fetch {"download for src.txz ${freebsd_version} (${architecture})":
      source      => "${version_url}/src.txz",
      destination => "${jail::freebsd_download_path}/src.txz",
      require     => File[$download_path]
    }
  }


}

