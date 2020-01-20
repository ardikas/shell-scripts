#!/bin/bash

#bootstrapping using user-data to update the system, install httpd, start httpd, enable httpd, and create a index.html file in the /var/www/html, 

yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>Hello World!</h1></html>" > index.html
