#!/bin/bash

MON_ONE=HDMI3
MON_TWO=DP1

MODE_ONE=1920x1080
MODE_TWO=1920x1080
#MODE_TWO=1024x768

VIRTUAL=vMon

# xrandr --output eDP1 --auto --left-of HDMI-1
# xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --output HDMI1 --mode 1920x1080 --pos 0x0
# xrandr --listmonitros
# xrandr --setmonitor Vmon auto eDP1,HDMI1

CMD="xrandr --output ${MON_ONE} --primary --mode ${MODE_ONE} --output ${MON_TWO} --mode ${MODE_TWO}"

case $1 in
    left)
	CMD="${CMD} --left-of ${MON_ONE}"
	;;
    right)
	CMD="${CMD} --right-of ${MON_ONE}"
	;;
    dual)
	CMD="${CMD} --pos 0x0"
	;;
    off)
	CMD="xrandr --output ${MON_ONE} --mode ${MODE_ONE} --primary --output ${MON_TWO} --off"
	;;
    mono)
	CMD="xrandr --setmonitor ${VIRTUAL} auto ${MON_ONE},${MON_TWO}"
	;;
    mono-off)
	CMD="xrandr --delmonitor ${VIRTUAL}"
	;;
    *)
	echo "commands: left, right, dual, mono, off"
	exit 0
	;;
esac

case $2 in
    rleft)
	CMD="${CMD} --rotate left"
	;;

    rright)
	CMD="${CMD} --rotate right"
	;;

    rnormal)
	CMD="${CMD} --rotate normal"
	;;
esac

echo ${CMD}

`${CMD}`
