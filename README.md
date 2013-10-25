## Binarysolo

*Works for me; should work for you*

https://github.com/felixroeser/binarysolo

### Motivation

*Host [Stringer](https://github.com/swanson/stringer) on a cheap [DigitalOcean](https://www.digitalocean.com/) 5$ box
and add some goodies like gitolite, jekyll and a http reverse proxy fully managed with Vagrant and Ansible*

### Vision

Manage arbitrary development boxes and have a constant homebase

### Getting started

* Follow the [installation steps](docs/install.md)

````
# Go whereever you want to store your binarysolo config directory
cd
~/PATH/bin/binarysolo init my_binarysolo
cd my_binarysolo
````
* Read the [configuration help](docs/configuration.md)
* configure your setup

```
# be patient - provisioning the box takes some time
~/PATH/bin/binarysolo homebase ensure
# apply the configured dns records to the digital ocean nameserver
~/PATH/bin/binarysolo dns update
# SSL TBA
```
* Commit save your setup ````git add . ; git commit -m 'initial setup'````

Done! Log into your box using: ```vagrant ssh``` and read about the [other components](docs/components.md)

### Unsubscribe!

````
vagrant destroy
````

but this won't remove any dns records and all data on your homebase will be gone! better check the digital ocean webui (or api) that your droplet is really gone.

### Pitfalls

* Digital Ocean might assign the same ip address to a droplet again when you play around causing ````vagrant ssh```` to fail. Check your ````~/.ssh/known_hosts```` for an old entry

### More

[MIT License](LICENSE.txt) [todo list](TODO.md) [changelog](CHANGELOG.md)