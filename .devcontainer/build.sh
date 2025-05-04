#!/bin/bash
set -e

rm -rf /opt/build/*
cp -r . /opt/build/

ORIG_DIR=$(pwd)

cd /opt/build
#west build -p always -b esp32c6_devkitc/esp32c6 -- -DDTC_OVERLAY_FILE=boards/esp32c6.overlay
echo invoking $ORIG_DIR/$1
$ORIG_DIR/$1

cd $ORIG_DIR
mkdir -p bin
cp /opt/build/build/zephyr/zephyr.bin /opt/build/build/zephyr/zephyr.elf bin/
