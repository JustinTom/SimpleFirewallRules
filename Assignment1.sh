#!/bin/bash

echo "These are the pre-existing iptable rules:"
echo "--------------------------------------"
iptables -L -n -v -x
echo "--------------------------------------"

#Set the default policies to DROP
echo "Setting default policies to DROP..."
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

#Drop inbound traffic to port 80 (http) from source ports less than 1024.
echo "Disabling all inbound traffic on port 80 and from source ports less than 1024..."
#Uses negate option in combination with ACCEPT since the default policy is DROP (this rule will override the DROP since it's sequentially lower down)
iptables -A INPUT -p tcp --dport 80 --sport 0:1023 -j DROP
iptables -A INPUT -p tcp ! --sport 0:1023 --dport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp ! --dport 0:1023 --sport 80 -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 80 --dport 0:1023 -j DROP

#Drop all incoming packets from reserved port 0 as well as outbound traffic to port 0
echo "Dropping all incoming packets from port 0 as well as outbound traffic to port 0..."
iptables -A INPUT -p tcp --sport 0 -j DROP
iptables -A INPUT -p udp --sport 0 -j DROP
iptables -A OUTPUT -p tcp --dport 0 -j DROP
iptables -A OUTPUT -p udp --dport 0 -j DROP

#Allow DNS packets
echo "Allowing all DNS packets..."
iptables -A INPUT -p tcp --sport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

#Allow DHCP packets
echo "Allowing all DHCP packets..."
iptables -A INPUT -p udp --dport 67:68 -j ACCEPT
iptables -A INPUT -p udp --sport 67:68 -j ACCEPT
iptables -A OUTPUT -p udp --sport 67:68 -j ACCEPT
iptables -A OUTPUT -p udp --dport 67:68 -j ACCEPT

#User defined chains for accounting rules
iptables -N SSH_IN_ACCT
iptables -N SSH_OUT_ACCT
iptables -N HTTP_IN_ACCT
iptables -N HTTP_OUT_ACCT
iptables -N HTTPS_IN_ACCT
iptables -N HTTPS_OUT_ACCT

iptables -A SSH_IN_ACCT -j ACCEPT
iptables -A SSH_IN_ACCT -j ACCEPT
iptables -A SSH_OUT_ACCT -j ACCEPT
iptables -A SSH_OUT_ACCT -j ACCEPT

iptables -A HTTP_IN_ACCT -j ACCEPT
iptables -A HTTP_OUT_ACCT -j ACCEPT
iptables -A HTTP_IN_ACCT -j ACCEPT
iptables -A HTTP_OUT_ACCT -j ACCEPT

iptables -A HTTPS_IN_ACCT -j ACCEPT
iptables -A HTTPS_IN_ACCT -j ACCEPT
iptables -A HTTPS_OUT_ACCT -j ACCEPT
iptables -A HTTPS_OUT_ACCT -j ACCEPT

#Permit inbound/outbound ssh packets
echo "Allowing inbound and outbound SSH packets..."
iptables -A INPUT -p tcp --dport 22 -j SSH_IN_ACCT
iptables -A INPUT -p tcp --sport 22 -j SSH_IN_ACCT
iptables -A OUTPUT -p tcp --dport 22 -j SSH_OUT_ACCT
iptables -A OUTPUT -p tcp --sport 22 -j SSH_OUT_ACCT

#Permit inbound/outbound www packets
echo "Allowing inbound and outbound www packets..."
iptables -A INPUT -p tcp --sport 80 -j HTTP_IN_ACCT
iptables -A OUTPUT -p tcp --dport 80 -j HTTP_OUT_ACCT
iptables -A INPUT -p tcp --dport 80 -j HTTP_IN_ACCT
iptables -A OUTPUT -p tcp --sport 80 -j HTTP_OUT_ACCT

#For https
iptables -A INPUT -p tcp --dport 443 -j HTTPS_IN_ACCT
iptables -A OUTPUT -p tcp --sport 443 -j HTTPS_OUT_ACCT
iptables -A INPUT -p tcp --sport 443 -j HTTPS_IN_ACCT
iptables -A OUTPUT -p tcp --dport 443 -j HTTPS_OUT_ACCT

echo "These are the new iptable rules:"
echo "--------------------------------------"
iptables -L -n -v -x
echo "--------------------------------------"
