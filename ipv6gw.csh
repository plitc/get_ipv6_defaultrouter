#!/bin/sh
### ### ### PLITC ### ### ###


### stage0 // ###
UNAME=$(uname)
MYNAME=$(whoami)
IF1=$(ifconfig | grep -e 'wlan0' -e 'lagg0' -e 'vswitch0' | awk '{print $1}' | sed '/laggport:/d' | sed '/inet6/d' | sed '/member:/d' | sed 's/://' | awk '{print}' ORS=' ' | awk '{print $1}')
IF2=$(ifconfig | grep -e 'wlan0' -e 'lagg0' -e 'vswitch0' | awk '{print $1}' | sed '/laggport:/d' | sed '/inet6/d' | sed '/member:/d' | sed 's/://' | awk '{print}' ORS=' ' | awk '{print $2}')
IF3=$(ifconfig | grep -e 'wlan0' -e 'lagg0' -e 'vswitch0' | awk '{print $1}' | sed '/laggport:/d' | sed '/inet6/d' | sed '/member:/d' | sed 's/://' | awk '{print}' ORS=' ' | awk '{print $3}')
ROUTERMC1=$(ping6 -I lagg0 -c 1 ff02::02 | grep fe80 | tail -n 1 | awk '{print $4}' | sed 's/,//')
ROUTERMC2=$(ping6 -I vswitch0 -c 1 ff02::02 | grep fe80 | tail -n 1 | awk '{print $4}' | sed 's/,//')
ROUTERMC3=$(ping6 -I wlan0 -c 1 ff02::02 | grep fe80 | tail -n 1 | awk '{print $4}' | sed 's/,//')
DEFAULTROUTER=$(grep "ipv6_defaultrouter" /etc/rc.conf | sed 's/ipv6_defaultrouter="fe80::1%//' | sed 's/"//')
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
if [ $IF1 = $DEFAULTROUTER ]; then
   echo "<--- --- --->"
   echo ""; echo "use lagg0 interface = OK "; echo ""
   route del -inet6 default; route add -inet6 default $ROUTERMC1
   exit 0
else
   # ipv6gw
fi
#
if [ $IF2 = $DEFAULTROUTER ]; then
   echo "<--- --- --->"
   echo ""; echo "use vswitch0 interface = OK "; echo ""
   route del -inet6 default; route add -inet6 default $ROUTERMC2
   exit 0
else
   # ipv6gw
fi
#
if [ $IF3 = $DEFAULTROUTER ]; then
   echo "<--- --- --->"
   echo ""; echo "use wlan0 interface = OK"; echo ""
   route del -inet6 default; route add -inet6 default $ROUTERMC3
   exit 0
else
   # ipv6gw
fi
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
