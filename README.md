# sent-hil.com

This repo contains all the apps running on [sent-hil.com](sent-hil.com). It's all managed by [dokku](http://dokku.viewdocs.io/dokku/).

So far there's:

* terraform - contains terraform scripts to bring up a VPC with RDS and EC instance running dokku
* blog - Jekyll app that powers the root [sent-hil.com](sent-hil.com).
* graph - [Hasura](https://hasura.io) app
* stats - [Goatcounter](https://www.goatcounter.com) app

If you're going to use this to create a similar setup, I would highly recommend you install fail2ban and harden the EC2 instance.
