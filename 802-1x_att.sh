#!/bin/sh
# ATT 802.1x Bridge Adapter Setup Script
# Created: 2024-04-20

###
## Stage 0: Set Variables
###
export OPENSSL_CONF=/opt/att/openssl.cnf
WPA_CONF_PATH=
PORT_ISP=
PORT_1=
PORT_2=
BRIDGE_NAME=br0

###
# Stage 1: Enable 802.1x Redirection on WAN Port
###
/usr/bin/ebtables -t nat -A PREROUTING -i $PORT_ISP -p 0x888e --log-level 6 -j redirect
/usr/bin/ebtables -t nat -A POSTROUTING -o $PORT_ISP -p 0x888e --log-level 6 -j snat --to-src `awk --field-separator '["#]' '/identity=/ { print $2}' "$WPA_CONF_PATH/wpa_supplicant.conf"`

###
# Stage 2: Configure Bridge and enable WAN port
###
/usr/bin/ip link add name $BRIDGE_NAME type bridge group_fwd_mask 8
/usr/bin/ip link set $BRIDGE_NAME multicast off
/usr/bin/ip link set $PORT_ISP master $BRIDGE_NAME
/usr/bin/ip link set $PORT_1 master $BRIDGE_NAME
/usr/bin/ip link set $PORT_2 master $BRIDGE_NAME
/usr/bin/ip link set master $BRIDGE_NAME
/usr/bin/ip link set $PORT_ISP up
/usr/bin/ip link set $BRIDGE_NAME up

###
# Stage 3: 802.1x Authentication
###
wpa_supplicant -B -Dwired -i $BRIDGE_NAME -c "$WPA_CONF_PATH/wpa_supplicant.conf" -P/var/run/wpa_supplicant.pid
sleep 10
wpa_cli logon
sleep 3

###
# Stage 4: Enable additional ports
###
ip link set dev $PORT_1 up
ip link set dev $PORT_2 up
