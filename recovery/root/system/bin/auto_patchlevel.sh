#!/sbin/sh
# Auto-detect security patch level from system partition
# This ensures TWRP's keymaster sees the correct patch level for FBE decryption

LOG_TAG="[AutoPatchLevel]"
RECOVERY_LOG="/tmp/recovery.log"

log_info() {
    echo "$LOG_TAG $1" >> "$RECOVERY_LOG"
    echo "$LOG_TAG $1" >&2
}

log_info "Starting auto patch level detection..."

# Note: Security patch levels are now set directly in init.recovery.qcom.rc
# This script is kept for logging and future enhancements

PATCH_LEVEL=""

# Method 1: Try mounted system
if [ -f /system_root/system/build.prop ]; then
    PATCH_LEVEL=$(grep -a "ro.build.version.security_patch=" /system_root/system/build.prop 2>/dev/null | head -1 | cut -d'=' -f2)
    if [ -n "$PATCH_LEVEL" ]; then
        log_info "Found in /system_root/system/build.prop: $PATCH_LEVEL"
    fi
fi

# Method 2: Try system block device via strings
if [ -z "$PATCH_LEVEL" ]; then
    for sys_dev in \
        /dev/block/bootdevice/by-name/system \
        /dev/block/mapper/system_a \
        /dev/block/mapper/system; do
        if [ -b "$sys_dev" ]; then
            log_info "Searching $sys_dev..."
            PATCH_LEVEL=$(dd if="$sys_dev" bs=1M count=100 2>/dev/null | strings | grep -a "ro.build.version.security_patch=" | head -1 | cut -d'=' -f2)
            if [ -n "$PATCH_LEVEL" ]; then
                log_info "Found in $sys_dev: $PATCH_LEVEL"
                break
            fi
        fi
    done
fi

# Method 3: Search super partition
if [ -z "$PATCH_LEVEL" ]; then
    SUPER_DEV="/dev/block/bootdevice/by-name/super"
    if [ -b "$SUPER_DEV" ]; then
        log_info "Searching super partition..."
        for skip in 0 50 100 150 200; do
            PATCH_LEVEL=$(dd if="$SUPER_DEV" bs=1M skip=$skip count=100 2>/dev/null | strings | grep -a "ro.build.version.security_patch=" | head -1 | cut -d'=' -f2)
            if [ -n "$PATCH_LEVEL" ]; then
                log_info "Found in super (offset ${skip}MB): $PATCH_LEVEL"
                break
            fi
        done
    fi
fi

if [ -n "$PATCH_LEVEL" ]; then
    log_info "Detected security patch level: $PATCH_LEVEL"
    log_info "Note: Values are set in init.recovery.qcom.rc"
else
    log_info "Could not detect security patch level from system partition"
    log_info "Using hardcoded values from init.recovery.qcom.rc"
fi

log_info "Auto patch level detection complete"

# Create done marker file for init synchronization
touch /tmp/auto_patchlevel_done

exit 0
