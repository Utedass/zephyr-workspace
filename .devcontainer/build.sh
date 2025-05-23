#!/bin/bash
set -e

echo "Cleaning up build directory.."
rm -rf /opt/build/*
echo "Copying work directory.."
cp -r . /opt/build/

ORIG_DIR=$(pwd)

cd /opt/build
#west build -p always -b esp32c6_devkitc/esp32c6 -- -DDTC_OVERLAY_FILE=boards/esp32c6.overlay
echo "Invoking build command from $ORIG_DIR/$1"
source $ORIG_DIR/$1

echo "Copying artifacts back to work directory/bin.."
artifact_endings=("bin" "elf" "uf2" "map" "hex")
cd build/zephyr
mkdir -p $ORIG_DIR/bin
rm -rf $ORIG_DIR/bin/*
for ext in "${artifact_endings[@]}"; do
    file="zephyr.${ext}"
    if [[ -f $file ]]; then
        cp $file $ORIG_DIR/bin/
        echo "Copied $file"
    else
        echo "$file not present, skipping"
    fi
done

# Diff configs if changed
if [[ -f .config.old ]]; then
    echo "Changed config detected. Diffing and saving diff"
    diff --unchanged-group-format= --changed-group-format=%\>  -biw  .config.old .config > $ORIG_DIR/bin/kconfig.diff
else
    echo "No changed config to diff, skipping"
fi
