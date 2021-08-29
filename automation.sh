#!/bin/bash

s3_bucket="s3://upgrad-tanvir"
myname=Tanvir
timestamp=$(date '+%d%m%Y-%H%M%S')
sudo apt-get update -y

# Below code to check whether apache2 installed or not, if not then install it.
pkgs='apache2'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
	sudo apt-get install $pkgs -y
fi

#Below code will check apache2 service is enabled or not, if not then enable it.
apache2_check="$(systemctl status apache2.service | grep Active | awk {'print $3'})"
if [ "${apache2_check}" = "(dead)" ]; then
	sudo systemctl enable apache2.service
fi

#Below code will check whether apache2 is running or not, if not then start the service.
ServiceStatus="$(systemctl is-active apache2.service)"
if [ "${ServiceStatus}" != "active" ]; then
	sudo systemctl start apache2.service
fi

#Below code will tar the log files of apache2 and move into the s3-bucket.
cd /var/log/apache2 && tar -cvf /tmp/$myname-httpd-logs-$timestamp.tar *.log
aws s3 cp /tmp/ $s3_bucket  --recursive --exclude "*" --include "*.tar"
