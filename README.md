# Homelab Deployment
This is an on-prem, bare metal homelab setup to run Kubernetes.  

This project leverages [Puppet Bolt](https://puppet.com/docs/bolt/latest/bolt.html) to install Kubernetes on each of the bare metal servers.

# Hardware components necessary for this deployment

|**#**| **Name** | **CPU Core Count** \||\| **Memory (GiB)** \||\| **HDD Size (GB)** \||\| **2nd HDD Size (TB)** | **NIC 1 IP** | **NIC 2 IP** | **GPU**
|-|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
|01|xg-7100|-|-|-|-|10.10.1.1/24|n/a|n/a|
|02|unifi 16 port PoE Switch|-|-|-|-|10.10.3.7/24|n/a|n/a|
|03|dev-mstr-01|4|16|232|-|10.10.100.10/24|n/a|n/a|
|04|dev-wrkr-01|4|16|232|1|110.10.100.9/24|n/a|n/a|
|05|dev-wrkr-02|4|16|232|1|10.10.100.8/24|n/a|n/a|
|06|msi-2060|16|32|1000|2|10.10.100.11/24|10.10.200.10|nvidia-2060|
|07|prd-mstr-01|4|8|128|-|10.10.200.5/24|n/a|n/a|
|08|prd-mstr-02|4|8|128|-|10.10.200.6/24|n/a|n/a|
|09|prd-wrkr-01|16|16|232|2|10.10.200.7/24|n/a|n/a|
|10|prd-wrkr-02|16|16|232|2|10.10.200.8/24|n/a|n/a|
|11|prd-wrkr-03|16|16|232|2|10.10.200.9/24|n/a|n/a|

# Software needed for this setup

[Ubuntu 18.04 Server](https://releases.ubuntu.com/18.04/ubuntu-18.04.4-live-server-amd64.iso) will be used for each Kubernetes nodes.  

The below is needed on the system running the bolt install process. In my case, OSX is being used.
* [Puppet Bolt](https://puppet.com/docs/bolt/latest/bolt_installing.html)
* [hiera-eyaml](https://packages.ubuntu.com/search?keywords=hiera-eyaml)

The process to setup each cluster is as follows;

- Install the Ubuntu server on each node enabling ssh
- Configure user for passwordless sudo
- Copy ssh keys to each node
- Generate Kuberenetes keys
- Encrypt keys using hiera-eyaml 
- Place keys in files
  - Ubuntu.yaml
  - k8s-primary.yaml
  - k8s-workerX.yaml
- Run `bolt plan run deploy_k8s::init_master -v env=dev`
  -  this also installs calico
- Run `bolt plan run deploy_k8s::init_workers -v env=dev`
- Run `bolt plan run deploy_k8s::install_rook -v env=dev`
- Run `bolt plan run manage_k8s::deploy_metallb target=dev-mstr-01`
- Run `bolt plan run manage_k8s::deploy_kubeflow -v env=dev`
- Run `bolt plan run manage_k8s::deploy_jenkinsx -v env=dev`
- Run `bolt plan run manage_k8s::deploy_elasticsearch -v env=dev`
- Run `bolt plan run manage_k8s::deploy_docure -v env=dev`
- Run `bolt plan run manage_k8s::deploy_git-metrics -v env=dev`



