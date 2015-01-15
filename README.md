# genconf
Simple script to generate and publish cinder.conf.sample

It was too hard for people to fix things back when we gated on checking sample.conf in
OpenStack/Cinder, so folks chose to remove the test.  This of course means nobody is
paying attention to when things break, and there's no published up to date sample.conf.

This is a hacky little script that I can run on my workstation nightly and via cron
and publish to my website.

* Clones current cinder master
* Runs tox -egenconfig
* Emails me with result
* Publishes new conf file to web server
