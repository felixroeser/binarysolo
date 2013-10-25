# Installation

## Requirements

* A digital ocean account 
  * you can spare $0.007/hour
  * grab your api_key and a client_id
* Vagrant 1.3+ (will go away at some point)
* Ansible 1.3
* Ruby (tested with 2.0)
* A dedicated domain: kinda pointless without. [Read on](docs/dns.md) for details

### OSX

```
# download and install Vagrant http://downloads.vagrantup.com/
brew install ansible
brew install curl-ca-bundle
# better add this to your .bash_profile
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
```

### Ubuntu

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

## Together again

```
# Not provided yet: gem install binarysolo
git clone https://github.com/felixroeser/binarysolo
cd binarysolo
bundle
vagrant install vagrant-omnibus
vagrant install vagrant-digitalocean
```

Now get back to [getting started](../README.md) again