## Binarysolo

*Works for me; will soon work for you*

https://github.com/felixroeser/binarysolo


### Installation

Requirements

* Vagrant 1.3+
* Ansible 1.3
* Ruby
* A dedicated domain: kinda pointless without - at least you have to setup A records with your current dns provider

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
bundle install
thor bootstrap:install_deps
```

**Let's do some basic configuration**

* Get a [Digitalocean](https://www.digitalocean.com) account
  * we will be fine with the 0.7ct/hour instance
  * get a client_id and api_key [here](https://www.digitalocean.com/api_access)
* Create and edit `config/custom.yml` overwriting the settings in [config/base.yml](config/base.yml) - use [config/custom.sample.yml](config/custom.sample.yml) as a blueprint
  * Required
    * **TBA**
  * Optional
    * **TBA**

```
thor homebase:vagrantfile
thor homebase:playbooks
vagrant up --provider digital_ocean
# be patient - provisioning the box takes some time
thor homebase:dns
# ssh into your new box and have a look around
vagrant ssh
```