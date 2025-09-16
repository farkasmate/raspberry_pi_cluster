#!/bin/sh -eu

apk add --no-cache \
  bluez \
  bluez-deprecated \
  dbus

rm -f /run/dbus/dbus.pid
dbus-daemon --system

btattach -B /dev/ttyAMA0 -P bcm -S 115200 -N &

exec /usr/lib/bluetooth/bluetoothd -n
