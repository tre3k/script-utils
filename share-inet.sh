#!/usr/bin/env bash

if [[ -z $FROM_IFACE ]]; then FROM_IFACE=wlan0; fi
if [[ -z $TO_IFACE ]]; then TO_IFACE=eth0; fi

IPTABLES=iptables
SYSCTL=sysctl

function execCommand() {
	echo $1
	`$1`
}

function enable() {
	${SYSCTL} net.ipv4.ip_forward=1
	${SYSCTL} net.ipv4.conf.all.forwarding=1
	${SYSCTL} net.ipv6.conf.all.forwarding=1

	execCommand "${IPTABLES} -P FORWARD ACCEPT"
	execCommand "${IPTABLES} -t nat -A POSTROUTING -o ${FROM_IFACE} -j MASQUERADE"
	execCommand "${IPTABLES} -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"
	execCommand "${IPTABLES} -A FORWARD -i ${TO_IFACE} -o ${FROM_IFACE} -j ACCEPT"

	echo share internet from ${FROM_IFACE} to ${TO_INFACE} enabled
}

function disable() {
	${SYSCTL} net.ipv4.ip_forward=0
	${SYSCTL} net.ipv4.conf.all.forwarding=0
	${SYSCTL} net.ipv6.conf.all.forwarding=0

	execCommand "${IPTABLES} -t nat -D POSTROUTING -o ${FROM_IFACE} -j MASQUERADE"
	execCommand "${IPTABLES} -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT"
	execCommand "${IPTABLES} -D FORWARD -i ${TO_IFACE} -o ${FROM_IFACE} -j ACCEPT"

	echo share internet from ${FROM_IFACE} to ${TO_INFACE} disabled
}

if [[ $1 == "enable" ]]
then
	enable
	exit
fi

if [[ $1 == "disable" ]]
then
	disable
	exit
fi

echo $0 "<enable/disable>"
echo "you can set env. variables: TO_IFACE & FROM_IFACE, default: eth0 & wlan0"
