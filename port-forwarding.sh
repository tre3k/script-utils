#!/usr/bin/env bash
# Скрипт проброса портов
# <to_iface/addr/port> - внешний интерфейс для доступа из вне, адресс и порт
# <from_iface/addr/port> - интерфейс смотрящий в локальную сеть, адрес локального сервера и порт

function help () {
    echo $prg $1 "<enable/disable>
    <to_iface> <to_addr> <to_port> <from_iface> <from_addr> <from_port>"
}

if [[ $# != '7' ]]
then
    help $0
    exit
fi

TO_IFACE=$2
TO_ADDR=$3
TO_PORT=$4
FROM_IFACE=$5
FROM_ADDR=$6
FROM_PORT=$7

RULE1=PREROUTING\ --dst\ $TO_ADDR\ -p\ tcp\ --dport\ $TO_PORT\ -j\ DNAT\ --to-destination\ $FROM_ADDR:$FROM_PORT
RULE2=-i\ $TO_IFACE\ -o\ $FROM_IFACE\ -d\ $FROM_ADDR\ -p\ tcp\ --dport\ $FROM_PORT\ -j\ ACCEPT
INSERT_RULE2=FORWARD\ 1\ $RULE2
RULE3=POSTROUTING\ --dst\ $FROM_ADDR\ -p\ tcp\ --dport\ $FROM_PORT\ -j\ SNAT\ --to-source\ $TO_ADDR
RULE4=OUTPUT\ --dst\ $TO_ADDR\ -p\ tcp\ --dport\ $TO_PORT\ -j\ DNAT\ --to-destination\ $FROM_ADDR:$FROM_PORT

case $1 in
    "enable")

	echo "add rules: "
	echo iptables -t nat -A $RULE1
	iptables -t nat -A $RULE1
	echo iptables -I $INSERT_RULE2
	iptables -I $INSERT_RULE2
	echo iptables -t nat -A $RULE3
	iptables -t nat -A $RULE3
	echo iptables -t nat -A $RULE4
	iptables -t nat -A $RULE4
    ;;

    "disable")
	echo "remove rules: "
	echo iptables -t nat -D $RULE1
	iptables -t nat -D $RULE1
	echo iptables -D FORWARD $RULE2
	iptables -D FORWARD $RULE2
	echo iptables -t nat -D $RULE3
	iptables -t nat -D $RULE3
	echo iptables -t nat -D $RULE4
	iptables -t nat -D $RULE4
    ;;

    *)
	help $0
    ;;
esac
