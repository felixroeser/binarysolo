Now do some basic configuration:

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
