# SimpleFirewallRules
A basic bash script to implement a simple personal Linux firewall.

The firewall rules will create a set of rules to:
- Set the default policies to DROP
- Permit inbound/outbound SSH packets
- Permit inbound/outbound www (HTTP + HTTPS) packets
  - Drop all traffic to port 80 from source ports that are less than 1024
- Drop all incoming and outgoing packets to and from port 0.

The firewall will also create two user defined chains that will implement accounting rules for both WWW and SSH traffic.
  
