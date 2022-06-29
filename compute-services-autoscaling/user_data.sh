#!/bin/bash
yum install httpd -y
systemctl start httpd
systemctl stop firewalld
cd /var/www/html
echo "this is my test site and the instance-id is " > index.html
curl http://169.254.169.254/latest/meta-data/instance-id >> index.html