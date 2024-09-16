# Command Line Fu
command to help out for when you in the terminal\
--------------------------------------------------------\
**###normal rsync**\
rsync -avzh root@source.com:/pwd/ destination/pwd/file   ###from server to server\
rsync -avh thisfolder tootherfolder   ##works like diff will only copy what is not there\
\
**###jump via another host that can connect to destination**\
rsync -avzh -e "ssh -J root@source1.com,root@source2.com" root@source.com:/pwd/ destination/pwd/file\
\
**###pivot ssh**\
ssh -t root@source.com ssh root@destination.com\
\
**###ettercap**\
ettercap -T -S -q -M arp:remote /<ipaddr_client>// /<ipaddr_router>// #ettercap mitm\
\
**###only show mac address and vendor with ipaddress**\
nmap -sn 10.10.10.0/24 | awk '/Nmap scan report for/{printf $5;}/MAC Address:/{print " => "substr($0, index($0,$3)) }' | sort\
\
**###short update and upgrade**\
apt update ; apt upgrade\
\
**###change mnt directory to mount drive**\
ls -lsah / | egrep -e "mnt" | awk {'print $2,$6,$10'} | sed -e "s/mnt/mount drive/g" | cut -d "e" -f 1\
\
**###calculator**\
echo $((4 + 2))\
\
**###samba connect**\
smbclient -L 10.0.0.50\
smbclient -N -L \\\\YOUR_TARGET_IP\\DIRECTORY_NAME\
smbclient //10.0.0.50/sharedFolderName/ -m SMB3\
\
**###change mac address**\
ifconfig eth0 down \
ifconfig eth0 hw ether 02:5d:6c:e8:8d:b2 \
ifconfig eth0 up \
\
**###check if eth0 mac address has changed**\
tcpdump -i eth0 -e -n "icmp and host 192.168.0.2"\
\
**###mac to monitor mode**\
ifconfig eth0 down \
ifconfig eth0 mode monitor \
ifconfig eth0 up \
\
**###generate ssh keys**\
ssh-keygen -t ed25519 -C "your_email@example.com"\
\
<sup><sub>Note: If you are using a legacy system that doesn't support the Ed25519 algorithm, use:</sub></sup>\
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"\
\
**###generate ssl certificate 2048 bit strong - no CA**\
openssl genrsa -out epp.key 2048\
openssl req -new -x509 -key epp.key -out epp.crt -days 365\
cat epp.key epp.crt > epp.pem\
\
**###show contents of ssl certificate**\
openssl s_client x509 -in name.crt -text -noout\
\
**###connect to server**\
openssl s_client -connect server.com -cert name.crt -key name.key -verify 10 -debug\
\
**###connect to server check port**\
telnet 123.456.789.012 3386\
\
**###check the connection**\
tcpdump -n tcp and port 700\
\
**###check mysql and its logs**\
mysql -se "SHOW VARIABLES" | grep -e log_error -e general_log -e slow_query_log\
mysql -e "SELECT @@GLOBAL.log_error"\
tail -f $(mysql -Nse "SELECT @@GLOBAL.log_error")\
mysql -e "SHOW FULL PROCESSLIST;"\
\
**###parallel - multithreading usage**\
ls -lsah | parallel echo\
seq 1 | parallel /usr/bin/php8.1 test.php\
seq 10 | parallel /usr/bin/python3 --version\
\
**###for loop file**\
for i in $(cat list);do echo $i; done\
\
**###random mac address**\
///file NAME: mac.sh
```
#!/bin/bash
LC_CTYPE=C
MAC=00:14:7C #3COM CARD
for i in {1..3}
do
    IFS= read -d '' -r -n 1 char < /dev/urandom
    MAC+=$(printf -- ':%02x\n' "'$char")
done
printf '%s\n' "$MAC"

# ----------------------------------------
# chmod +x mac.sh
# $ ./mac.sh 
# ba:aa:92:cf:38:2e
# use mac/oui address lookup file in git
```
# TCPDUMP 
Filtering ICMP echo reply echo request Packets with tcpdump command\
--------------------------------------------------------\
0 Echo Reply\
3 Destination Unreachable\
4 Source Quench\
5 Redirect\
8 Echo\
11 Time Exceeded\
--------------------------------------------------------\
With the following command, we can filter ICMP echo-reply,

**##### tcpdump -i eth0 “icmp[0] == 0”

To filter ICMP echo-requests, we can use this tcpdump command.

**##### tcpdump -i eth0 “icmp[0] == 8”

How to use tcpdump to capture ICMPv6 packets
In IPv6, an IPv6 packet is 40 bytes long, and the first 8 bits of the ICMPv6 header specify its type. We can use this tcpdump command to filter all ICMPv6 packets.

**##### tcpdump -i eth0 icmp6

We can use this tcpdump command to filter ICMPv6 echo-requests.

**##### tcpdump -i eth0 “icmp6 && ip6[40] == 128”

In the latest versions of tcpdump/libpcap, we can use the following command to capture ICMPv6 echo packets.

**##### tcpdump -i eth0 ‘icmp6[icmp6type]=icmp6-echo’





# AWK Commands
replace certain linux commands with AWK\
--------------------------------------------------------\

| awk_command  | linux_command | long way/description |
| ------------- | ------------- | ------------- |
| awk 1 test.sh  | cat test.sh  | awk '{print $0}' test.sh |
| awk '{IGNORECASE=1}/next/' test.sh | grep -i 'next' test.sh  | |
| awk '{gsub(/Next/, "linuxrules"); print}' test.sh | sed 's/Next/linux/' test.sh | |
| awk 'END{print NR}' test.sh | wc -l test.sh | |
| awk 'FNR <= 10' test.sh | head -n 10 test.sh | | 
| awk 'a[$0]++' test.sh | uniq -D test.sh | duplicates add ! to remove:: !a[$0]++ |

# WIFI HACKING
Commands used in wifi WPA2 hacking\
--------------------------------------------------------\
you will need a wifi card that can do packet injection and monitor mode... \
to test this use the following commands\

check card supports monitor mode\
**##### ifconfig wlan0 down\
**##### iwconfig wlan0 mode monitor\
**##### ifconfig wlan0 up\
**##### iwconfig ----- check if card is in monitor mode under man\

check card supports packet injection\
**##### terminal 1: airodump-ng wlan0\
**##### terminal 1: airodump-ng -c 2 -w packetcapture -d 00:00:00:00:00:00 wlan0\
**##### terminal 2: aireplay-ng --deauth -a 00:00:00:00:00:00 -c 00:00:00:00:00:00 wlan0\
**##### terminal 3: aircrack-ng packcapture.pcap -w passwords.txt


# SNORT RULES AND RUN
/etc/snort/rules/local.rules

alert icmp any any -> 192.168.0.0/24 any (msg: "NMAP ping sweep Scan"; dsize:0;sid:10000004; rev: 1;)

alert tcp any any -> 192.168.0.0/24 any (msg: "NMAP TCP Scan";sid:10000005; rev:2; )

alert tcp any any -> 192.168.0.0/24 any (msg:"Nmap XMAS Tree Scan"; flags:FPU; sid:1000006; rev:1; )

alert tcp any any -> 192.168.0.0/24 any (msg:"Nmap FIN Scan"; flags:F; sid:1000008; rev:1;)

alert tcp any any -> 192.168.0.0/24 any (msg:"Nmap NULL Scan"; flags:0; sid:1000009; rev:1; )

alert udp any any -> 192.168.0.0/24 any ( msg:"Nmap UDP Scan"; sid:1000010; rev:1; )

**##### terminal 1: sudo snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -i wlp1s0f0
