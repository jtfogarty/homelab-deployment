# This plan will configure the Unifi Controller.
# The VM necessary should be an Ubuntu 18.04 Server image.
plan deploy_applications::unifi_controller() {
  # Prep the server
  apply_prep('unifi')

  # Install Qemu-Guest-Agent and ensure the service is enabled and started.
  apply('unifi', _run_as => root) {

    # List of packages
    $package_list = [
      'qemu-guest-agent',
      'ca-certificates',
      'apt-transport-https'
    ]

    package {$package_list:
      ensure => 'installed',
    }

    service {'qemu-service':
      ensure => true,
      name   => 'qemu-guest-agent',
      enable => true,
    }  
  }

  # Prep and install the Unifi Controller
  apply('unifi', _run_as => root) {

    apt::key { 'mongodb-3.4':
      server => 'https://www.mongodb.org/static/pgp/server-3.4.asc'
    }
    # wget -qO - https://www.mongodb.org/static/pgp/server-3.4.asc | sudo apt-key add -
    # echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

    file { '/etc/apt/sources.list.d/100-ubnt-unifi.list':
      content => 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti',
    }

    file { '/etc/apt/sources.list.d/mongodb-org-3.4.list':
      content => 'deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse',
    }

  }
}
