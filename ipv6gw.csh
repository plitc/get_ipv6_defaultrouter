#!/bin/sh
#
### LICENSE // ###
#
# Copyright (c) 2014, Daniel Plominski (Plominski IT Consulting)
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
### // LICENSE ###
#
### ### ### PLITC // ### ### ###

### stage0 // ###
UNAME=$(uname)
MYNAME=$(whoami)
DEFAULTROUTER=$(grep "ipv6_defaultrouter" /etc/rc.conf | sed 's/ipv6_defaultrouter="fe80::1%//' | sed 's/"//')
ROUTERMULTICAST=$(ping6 -I `(grep "ipv6_defaultrouter" /etc/rc.conf | sed 's/ipv6_defaultrouter=//' | sed 's/fe80::1%//' | sed 's/"//g')` -c 1 ff02::2 | grep fe80 | tail -n 1 | awk '{print $4}' | sed 's/,//')
PACKETLOSS=$(ping6 -I `(grep "ipv6_defaultrouter" /etc/rc.conf | sed 's/ipv6_defaultrouter=//' | sed 's/fe80::1%//' | sed 's/"//g')` -c 1 ff02::2 | grep packet | tail -n 1 | awk '{print $7}' | sed 's/.0%//')
# PLITC - ipv6 testserver
TESTSERVER="2a01:4f8:131:200c::3:3544"
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
   echo 'ERROR: You must set ipv6_defaultrouter="fe80::1%interface" in /etc/rc.conf'
   exit 1
else
(
if [ $PACKETLOSS = 100 ]; then
   echo "<--- --- --->"
   echo ""
   echo "ERROR: ping6 failed, try again ..."
   echo ""
   (
   route del -inet6 default; route add -inet6 default fe80::1%$DEFAULTROUTER
   if [ $PACKETLOSS = 100 ]; then
      echo "<--- --- --->"
      echo ""
      echo "ERROR: ping6 failed, hopeless!"
      exit 1
   else
      route del -inet6 default; route add -inet6 default $ROUTERMULTICAST
      exit 0
   fi
   )
else
   route del -inet6 default; route add -inet6 default $ROUTERMULTICAST
   (
   echo ""
   echo "<--- --- --->"
   echo ""
   echo "traceroute6 test to PLITC:"
   echo ""
      (traceroute6 -n -v $TESTSERVER)
   )
   exit 0
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


### ### ### // PLITC ### ### ###
# EOF
