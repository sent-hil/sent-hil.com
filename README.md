# sent-hil.com

This repo contains all the apps running on [sent-hil.com](sent-hil.com). It's managed by [dokku](http://dokku.viewdocs.io/dokku/).

So far there's:

* terraform - contains terraform scripts to bring up a VPC with RDS and EC2 instance.
* blog - Jekyll app that powers the root [sent-hil.com](sent-hil.com) (public).
* graph - [Hasura](https://hasura.io) app (private).
* stats - [Goatcounter](https://www.goatcounter.com) app (private) for analytics.

The apps need to be submodules for dokku to work.

## Setup

```
git clone --recurse-submodules -j8 git@github.com:sent-hil/sent-hil.com.git
```

If you use this to create a similar setup, I recommend you install fail2ban and harden the EC2 instance.
