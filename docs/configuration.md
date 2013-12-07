Now do some basic configuration! **Beware there is litte to no error checking so far**

## config/digitalocean.yml

* Get a [Digitalocean](https://www.digitalocean.com) account
  * we will be fine with the 0.7ct/hour instance
  * get a client_id and api_key [here](https://www.digitalocean.com/api_access)
* Choose
  * size: 512MB (is enough), 1GB, 2GB ...
  * region: San Francisco 1, New York 1, Amsterdam 1

## config/homebase.yml

Better don't touch the file at all for now

## config/components/stringer.yml

* Set enabled to *true*
* Set random postgres_user_password ````openssl rand -base64 32````
* Point public_host to whatever you need
  * Binarysolo will add an A record to the Digital Ocean Nameserver
  * Manually set an A record at your domain's current nameserver if you don't want to move it

## config/dns/*

* Delete example.com.yml if you don't want BinarySolo to setup any custom records for you. 
* Create a yml file per domain and set the (manual) records that you need
  * A, TXT, CNAME, MX support right now

More details TBA

## Giteolite, Fwd, Jekyll, Nginx, SSL

**documentation tba** - Should work but better make sure that the basics are working and leave them disabled.