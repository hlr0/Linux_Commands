#!/bin/bash

#ip addr
curl ifconfig.me

#ip addr
curl icanhazip.com

#ip addr
curl ipecho.net/plain

#ip addr
curl ident.me

#ip addr
curl https://myip.dnsomatic.com

#ip addr
curl https://checkip.amazonaws.com

#ip addr
curl http://whatismyip.akamai.com

#ip addr
wget -qO- ifconfig.me

#DNS lookup 
dig +short myip.opendns.com @resolver1.opendns.com

#DNS lookup 
dig +short ANY whoami.akamai.net @ns1-1.akamaitech.net

#DNS lookup 
dig +short ANY o-o.myaddr.l.google.com @ns1.google.com
