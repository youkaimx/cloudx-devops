#!/bin/sh
yum -y update
yum -y install httpd
amazon-linux-extras install php7.2
yum -y install php-mbstring
yum -y install telnet
case $(ps -p 1 -o comm | tail -1) in
systemd) systemctl enable --now httpd ;;
init) chkconfig httpd on; service httpd start ;;
*) echo "Error starting httpd (OS not using init or systemd)." 2>&1
esac
if [ ! -f /var/www/html/s3-web-host.tar.gz ]; then
cd /var/www/html
wget https://workshop-objects.s3.amazonaws.com/general-id/s3_general_lab/s3-web-host.tar
tar xvf s3-web-host.tar
chown apache:root /var/www/html/labs/s3/s3.conf.php
chown apache:root /var/www/html/labs/s3/reset_config/s3.conf.php
fi
yum -y update