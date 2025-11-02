# Networking Labs

## Lab 1: Bring up a secondary IP
1) `ip addr add 192.0.2.20/24 dev eth0`
2) Verify: `ip a show dev eth0`
3) Remove: `ip addr del 192.0.2.20/24 dev eth0`

## Lab 2: Restrict SSH with firewall
- UFW: `ufw allow proto tcp from 10.0.0.0/24 to any port 22`
- firewalld: `firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=10.0.0.0/24 port port=22 protocol=tcp accept' && firewall-cmd --reload`
