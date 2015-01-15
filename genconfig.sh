#!/bin/bash

git pull
_NOW=$(date +"%m_%d_%Y")
_FNAME="cinder.conf.sample.$NOW.txt"
COMMAND="tox -egenconfig"

git clone https://github.com/openstack/cinder cinder.cfg
cd cinder.cfg
OUT=`mktemp` && ERR=`mktemp` && eval "$COMMAND" 1>$OUT 2>$ERR; STDOUT=`cat $OUT` && STDERR=`cat $ERR` && rm $OUT $ERR
echo $STDOUT > genconf_results
echo $STDERR >> genconf_results

if grep "ERROR: genconfig: commands failed" genconf_results
  then
    cat ./genconf_results | mail -s "Cinder Genconfig FAILED" john.griffith@solidfire.com
    scp ./genconf_results sfci:~/www/solidfire-ci-logs/cinder-conf-samples/cinder.conf.sample_FAILED_$_NOW.txt
  else
    cat ./genconf_results | mail -s "Cinder Genconfig PASSED" john.griffith@solidfire.com
    scp ./etc/cinder/cinder.conf.sample sfci:~/www/solidfire-ci-logs/cinder-conf-samples/cinder.conf.sample_$_NOW.txt
    scp ./etc/cinder/cinder.conf.sample sfci:~/www/solidfire-ci-logs/cinder-conf-samples/cinder.conf.sample.txt
  fi

cd ../
rm -rf cinder.cfg
