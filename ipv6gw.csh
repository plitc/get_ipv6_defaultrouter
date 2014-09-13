#!/bin/sh
### ### ### PLITC ### ### ###


### stage0 // ###
UNAME=$(uname)
MYNAME=$(whoami)
DEFAULTROUTER=$(grep "ipv6_defaultrouter" /etc/rc.conf | sed 's/ipv6_defaultrouter="fe80::1%//' | sed 's/"//')
ROUTERMULTICAST=$(ping6 -I `(grep "ipv6_defaultrouter" /etc/rc.conf | sed 's/ipv6_defaultrouter="fe80::1%//' | sed 's/"//')` -c 1 ff02::2 | grep fe80 | tail -n 1 | awk '{print $4}' | sed 's/,//')
### // stage0 ###


### stage1 // ###
case $UNAME in
FreeBSD)
   ### FreeBSD ###
### ### ### ### ### ### ### ### ###


### stage2 // ###
if [ $MYNAME = root ]; then
   # ipv6gw
else
   echo "<--- --- --->"
   echo ""
   echo "ERROR: You must be root to run this script"
   exit 1
fi
### // stage2 ###


### stage3 // ###
if [ -z "$DEFAULTROUTER" ]; then
   echo "<--- --- --->"
   echo ""
   echo "ERROR: You must set ipv6_defaultrouter=fe80::1%interface in /etc/rc.conf"
   exit 1
else
(
   route del -inet6 default; route add -inet6 default $ROUTERMULTICAST
   exit 0
)
fi
### // stage3 ###


### ### ### ### ### ### ### ### ###
   ;;
*)
   # error 1
   echo "<--- --- --->"
   echo ""
   echo "ERROR: Plattform = unknown"
   exit 1
   ;;
esac
### // stage1 ###


### ### ### PLITC ### ### ###
# EOF
