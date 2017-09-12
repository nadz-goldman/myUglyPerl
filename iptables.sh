#!/bin/bash
IPT="/sbin/iptables"
EC="/bin/echo"

### Administrative hosts
ADMINS="10.0.0.0/8 192.168.0.0/16"

### TCP services ports
ACCPOTCP=""

### UDP services ports
ACCPOUDP=""
 
case $1 in
stop)
    $IPT --flush
    $IPT --delete-chain
    $IPT --table nat --flush
    $IPT --table nat --delete-chain
    $IPT --table filter --flush
    $IPT --table filter --delete-chain
    $IPT -t filter -P INPUT ACCEPT
    $IPT -t filter -P OUTPUT ACCEPT
    $IPT -t filter -P FORWARD ACCEPT
    $EC "Firewall stopped"
;;
 
status)
    $IPT --list
;;
 
restart|reload)
    $0 stop
    $0 start
;;
 
start)
    $IPT --flush
    $IPT --delete-chain
    $IPT --table nat --flush
    $IPT --table nat --delete-chain
    $IPT --table filter --flush
    $IPT --table filter --delete-chain
    $IPT -P INPUT DROP
    $IPT -P OUTPUT ACCEPT
    $IPT -F INPUT
    $IPT -F OUTPUT
    $IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IPT -A INPUT -i lo -j ACCEPT


    ### LDAP
    $IPT -A INPUT -p tcp --dport 389 -s 127.0.0.0/8 -j ACCEPT -m comment --comment "LDAP only for local instance - ALLOW LOCALHOST ( port 389 )"
    $IPT -A INPUT -p tcp --dport 636 -s 127.0.0.0/8 -j ACCEPT -m comment --comment "LDAP only for local instance - ALLOW LOCALHOST ( port 636 )"
    $IPT -A INPUT -p tcp --dport 389 -j DROP -m comment --comment "LDAP only for local instance - DROP"
    $IPT -A INPUT -p tcp --dport 636 -j DROP -m comment --comment "LDAP only for local instance - DROP"

    ### Admins
    for admin_ips in $ADMINS;
    do
        $IPT -A INPUT -s $admin_ips -m state --state NEW -j ACCEPT
    done

    $IPT -A INPUT -p icmp --icmp-type timestamp-request -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
    $IPT -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
    $IPT -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
    $IPT -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
    $IPT -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
    $IPT -A OUTPUT -p icmp --icmp-type timestamp-reply -j DROP
    $IPT -A INPUT -p icmp --icmp-type 8 -j ACCEPT




    #### Open ports
    ### TCP
    if [[ -n "$ACCPOTCP" ]];
    then
        for z in $ACCPOTCP;
        do
            $IPT -A INPUT -p tcp -m tcp --dport $z -j ACCEPT
        done
    fi
    ### UDP
    if [[ -n "$ACCPOUDP" ]];
    then
        for x in $ACCPOUDP;
        do
            $IPT -A INPUT -p udp -m udp --dport $x -j ACCEPT
        done
    fi


    $EC "Firewall started"
;;
 
*)
    $EC "* Usage: $0 (start|stop|restart|status)"
    exit 1
;;
esac
 
exit 0

