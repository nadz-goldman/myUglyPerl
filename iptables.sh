#!/bin/bash
IPT=$( which iptables )
EC=$( which echo )
### Administrative hosts
ADMINS="192.168.192.0/24 10.20.30.40"
### TCP services ports
ACCPOTCP="22 80"
### UDP services ports
ACCPOUDP="51"
 
case $1 in
stop)
    $IPT --flush
    $IPT --delete-chain
    $IPT --table nat --flush
    $IPT --table nat --delete-chain
    $IPT --table filter --flush
    $IPT --table filter --delete-chain
    $IPT --table mangle --flush
    $IPT --table mangle --delete-chain
    $IPT -t filter -P INPUT ACCEPT
    $IPT -t filter -P OUTPUT ACCEPT
    $IPT -t filter -P FORWARD ACCEPT
    $EC "Firewall in state permit any-any"
;;
 
status)
    $IPT -L -n -v --line-numbers
;;
 
restart|reload)
    $0 stop
    $0 start
    $0 status
;;
 
start)
    $IPT --flush
    $IPT --delete-chain
    $IPT --table nat --flush
    $IPT --table nat --delete-chain
    $IPT --table filter --flush
    $IPT --table filter --delete-chain
    $IPT --table mangle --flush
    $IPT --table mangle --delete-chain
    $IPT -P INPUT DROP
    $IPT -P OUTPUT ACCEPT
    $IPT -F INPUT
    $IPT -F OUTPUT
    $IPT -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    $IPT -A INPUT -i lo -j ACCEPT

    ### LDAP
    $IPT -A INPUT -p tcp --dport 389 -s 10.0.0.1 -j ACCEPT -m comment --comment "LDAP - ALLOW LOCAL PC ( port 389 )"
    $IPT -A INPUT -p tcp --dport 636 -s 10.0.0.1 -j ACCEPT -m comment --comment "LDAP - ALLOW LOCAL PC ( port 636 )"

    ### LIGHTHTTPD
    $IPT -A INPUT -p tcp --dport 80 -j ACCEPT -m comment --comment "LightHTTPd ACCEPT FROM ANY"
    $IPT -A INPUT -p tcp --dport 443 -j ACCEPT -m comment --comment "LightHTTPd ACCEPT FROM ANY"

    ### RADIUS drop unknown clients
    $IPT -A INPUT -p tcp --dport 1812 -j DROP -m comment --comment "RADIUS only for friends - DROP"
    $IPT -A INPUT -p udp --dport 1812 -j DROP -m comment --comment "RADIUS only for friends - DROP"
    $IPT -A INPUT -p tcp --dport 1813 -j DROP -m comment --comment "RADIUS only for friends - DROP"
    $IPT -A INPUT -p udp --dport 1813 -j DROP -m comment --comment "RADIUS only for friends - DROP"

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


    $EC "Firewall in secured state"
;;
 
*)
    $EC "* Usage: $0 (start|stop|restart|status)"
    exit 1
;;
esac
 
exit 0