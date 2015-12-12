#!/bin/bash

echo "Flushing the iptable rules..."
#Flush the pre-existing iptable rules
iptables -F
echo "Deleting any user-defined chains..."
#Delete the pre-existing user-defined chains for accounting rules.
iptables -X

echo "Changing all default policies to ACCEPT"
#Changes the default policies (INPUT, OUTPUT, FORWARD) to ACCEPT
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
