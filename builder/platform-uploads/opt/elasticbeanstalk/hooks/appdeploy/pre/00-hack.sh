#!/bin/bash -xe

# Installing existing Jitsi-Meet repository using the quick-install method.
# More information at https://github.com/jitsi/jitsi-meet/blob/master/doc/quick-install.md
locator=thinq-tv.us-west-2.elasticbeanstalk.com
# IP could be replaced with domain name
#locator="$(dig +short locator.opendns.com @resolver1.opendns.com)"
down=$(tput cud1)
right=$(tput cuf1)
export locator
export down
export right
/usr/bin/expect << EOCF
	set timeout -1
	log_user 1
	spawn apt-get -y install jitsi-meet
	expect "The hostname of the current installation:*"
	sleep 0.2
	send "$::env(locator)\r"
	send "$::down"
	send "\r"
	expect "I want to use my own certificate"
	sleep 0.2
	send "$::env(right)"
	send "\r"
	expect eof
	
	spawn sh /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
	expect "Enter your email and press *"
	sleep 0.1
	send "gaknigh2@asu.edu\r"
	expect eof
EOCF

#whereis jitsi-meet
JITSI_DIR=/usr/share/jitsi-meet/
rm -rf $STAGING_DIR
mkdir -p $STAGING_DIR
mv -v $JITSI_DIR* $STAGING_DIR