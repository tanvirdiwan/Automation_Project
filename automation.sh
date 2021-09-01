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

#Below code will create the inventoryfile for bookkeeping if file does not exist.
size=$(sudo du -sh /tmp/${myname}-httpd-logs-${timestamp}.tar | awk '{print $1}')
if [ -e /var/www/html/inventory.html ]
then
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; ${size}" >> /var/www/html/inventory.html
else
echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp; Size</b><br>" > /var/www/html/inventory.html
echo "<br>httpd-logs &nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp; ${size}" >> /var/www/html/inventory.html
fi

# check cron file is exist or not, if it is doesn't exist then create it
# Note:- script will execute once in day at 12.30AM
if  [ ! -f  /etc/cron.d/automation ]
then
	echo  "30 0 * * * \troot\t/root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi

##-----Script End--------##
