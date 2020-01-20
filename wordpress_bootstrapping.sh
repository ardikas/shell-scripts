#!/bin/bash
yum update -y
yum install httpd php php-mysql -yumcd /var/www/html
echo "heatlhy" > healthy.html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpressr -rf latest.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
chkconfig httpd on

# Not necessary parts
wget https://s3.amazonaws.com/bucketforwordpresslab-donotdelete/htaccess.txt
mv httaccess.txt .htaccess

