#!/system/bin/sh
dd if=/dev/zero of=/dev/block/bootdevice/by-name/misc bs=1 count=13
