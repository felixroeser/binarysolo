You are using a designated ssh key with a strong passphrase? Make your like easier before working with you homebase:

````
ssh-agent
ssh-agent ssh/master_rsa.pub
````

## Gitolite

* Clone your admin repo: ````git clone git@example.com:gitolite-admin```
* Read the [documentation](http://gitolite.com/gitolite/admin.html)

## Stringer

* Just open the configured url in your browser and consume your rss feeds
* Currently a fork is being deployed as the original branch doesn't support setting the password programmatically

### Updating:

No auto updating => You have to do it yourself

````
vagrant ssh
sudo su - stringer
cd stringer
git pull
...
````

## Fwd

````
~/PATH/bin/binarysolo fwd PORT
````

## Jekyll

Jekyll sites aren't stored in your gitolite setup (yet). 

* Clone your site, add posts and push to
* ````git clone jekyll@DOMAIN:SITENAME.git````
  * example ````git clone jekyll@example.com:example.git````
* If that site wasn't deployed from a template repo your site repo will be blank:
  * Install jekyll locally ````gem install jekyll``` (details [here](http://jekyllrb.com/docs/quickstart/) )
  * cd into your empty repo
  * Scaffold your site ````jekyll new .````
  * Write stuff, commit and push.