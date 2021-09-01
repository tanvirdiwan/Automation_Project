# Automation_Project

This project will check the apache2 service is running well or not, it will also check the its enabled or not if its not enabled then script will enable apache service on boot level.

After this script will check the available error and access logs for apache2 and script will archieve(tar) the the logs on /tmp folder and then moving it into the s3 bucket.

Script will also managing the book-keeping data for archieved logs, we cab able to see howmany archieve files do we have so far... we can see inventory.html to see the records, please use server-ip/inventory.html URL to check the same.

Script will also make sure that cronjob is implemented or not, if not found then it will create cronjob for this script to run everyday at 12:30AM.

Thank You...!!
