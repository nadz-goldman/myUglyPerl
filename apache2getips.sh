#!/bin/bash

site=domain.com

cat /var/log/apache2/$site-error.log | awk '{print $10}' | sort -n | uniq -c | sort -nr | head -40 | cut -d : -f 1 | awk '{print $2}' > /root/apache2ips.txt

while read ips
do
    iptables -A INPUT -s $ips -j DROP -m comment --comment "ApacheSpam"
done < /root/apache2ips.txt

