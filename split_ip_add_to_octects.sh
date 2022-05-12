#! /bin/bash
echo -n " Enter the IP Address (Example: 192.168.160.0): "
read IP
oct1=$(echo ${IP} | tr "." " " | awk '{ print $1 }')
oct2=$(echo ${IP} | tr "." " " | awk '{ print $2 }')
oct3=$(echo ${IP} | tr "." " " | awk '{ print $3 }')
oct4=$(echo ${IP} | tr "." " " | awk '{ print $4 }')
echo "IP Address is $oct1 . $oct2 . $oct3 . $oct4"
