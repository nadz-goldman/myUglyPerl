#!/bin/bash

now=$(date +"%d-%m-%Y")

iptables-save > /root/iptables-$now.rules

iptables-save | grep -v "ApacheSpam" | iptables-restore

