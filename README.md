## Binarysolo

*Works for me; might work for you*

https://github.com/felixroeser/binarysolo

### Motivation

*Host [Stringer](https://github.com/swanson/stringer) on a cheap [DigitalOcean](https://www.digitalocean.com/) 5$ box
and add some goodies like gitolite, jekyll and a http reverse proxy*

### Vision

Manage arbitrary development boxes and have a constant homebase

### Installation

Requirements

* Vagrant 1.3+ (might go away at some point)
* Ansible 1.3
* Ruby
* A dedicated domain: kinda pointless without - at least you should have an A records with your current dns provider

#### OSX

```
# download and install Vagrant http://downloads.vagrantup.com/
brew install ansible
brew install curl-ca-bundle
# better add this to your .bash_profile
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
```

#### Ubuntu

```
# download and install Vagrant http://downloads.vagrantup.com/
wget http://files.vagrantup.com/packages/db8e7a9c79b23264da129f55cf8569167fc22415/vagrant_1.3.3_x86_64.deb -O /tmp/vagrant.deb
sudo dpkg -i /tmp/vagrant.deb
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:rquillo/ansible
sudo apt-get update
sudo apt-get install ansible
# better add this to your .bash_profile
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
```

### Together again

```
git clone https://github.com/felixroeser/binarysolo
cd binarysolo
bundle
thor bootstrap:install_deps
```

**Let's do some basic configuration**

* Get a [Digitalocean](https://www.digitalocean.com) account
  * we will be fine with the 0.7ct/hour instance
  * get a client_id and api_key [here](https://www.digitalocean.com/api_access)
* Create and edit `config/custom.yml` overwriting the settings in [config/base.yml](config/base.yml) - use [config/custom.sample.yml](config/custom.sample.yml) as a blueprint
  * Required
    * *ssh_key* point to your private key that will become the master key
    * *digitalocean*
      * *client_id* and *api_key*
  * Optional
    * *digitalocean*
      * *size* 512MB|1GB|2GB
      * *region* San Francisco 1|New York 1|New York 2|Amsterdam 1
  * Dont change for now:
    * *digitalocean*
      * *image* Postgres 9.3 ppa is only available for Ubuntu 12.04 x64
    * *homebase*
      * *hostname* leave this to homebase

* (Optional) Have ssl certificates ready for the domain you want to use and place them in ssl/domain
  * Use ````thor ssl:gen_crt example.com```` to generate a self signed certificate and key in ````ssl/example.com````
  * Or see [here](https://www.digitalocean.com/community/articles/how-to-create-a-ssl-certificate-on-nginx-for-ubuntu-12-04)

```
thor homebase:vagrantfile
thor homebase:playbooks
# be patient - provisioning the box takes some time
vagrant up --provider digital_ocean
# apply the configured dns records to the digital ocean nameserver
thor homebase:dns_setup
# ssh into your new box and have a look around
vagrant ssh
```

### Pitfalls

* Digital Ocean might assign the same ip address to a droplet again causing ````vagrant ssh```` to fail. Check your ````~/.ssh/known_hosts```` for an old entry
* customer.yml is in the 
* TODO
  * turn this into a real gem
  * get rid of vagrant
  * dive into roles and tags; start [here](https://gist.github.com/marktheunissen/2979474)
  * configure logrotate
  * add monitoring like [mosshe](http://www.wyae.de/software/mosshe/)
  * tests
  * play with [etcd](https://github.com/coreos/etcd) to store state
  * checkout dotfiles
  * the ssl setup is crap! http://www.g-loaded.eu/2005/11/10/be-your-own-ca/
  * far away country:
    * add a mail server
