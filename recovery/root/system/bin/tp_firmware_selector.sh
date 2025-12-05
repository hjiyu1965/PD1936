#!/system/bin/sh
# 触摸屏固件选择器
# 根据硬件版本动态选择并加载正确的触摸屏固件

LOG_FILE="/tmp/tp_firmware.log"
FIRMWARE_PATH="/vendor/firmware"

# 清空日志文件
echo "=== TP Firmware Selector $(date) ===" > $LOG_FILE

# 函数：记录日志
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# 函数：检查文件是否存在
check_file() {
    if [ -f "$1" ]; then
        log "Found: $1"
        return 0
    else
        log "Missing: $1"
        return 1
    fi
}

# 函数：获取硬件版本信息
get_hardware_version() {
    local hw_version=""
    
    # 尝试从多个位置获取硬件版本
    if [ -f "/proc/device-tree/model" ]; then
        hw_version=$(cat /proc/device-tree/model)
        log "Device tree model: $hw_version"
    fi
    
    if [ -f "/proc/cmdline" ]; then
        hw_version=$(cat /proc/cmdline | grep -o "androidboot.hw_version=[^ ]*" | cut -d= -f2)
        log "Cmdline hw_version: $hw_version"
    fi
    
    if [ -f "/sys/class/drm/card0/device/version" ]; then
        hw_version=$(cat /sys/class/drm/card0/device/version)
        log "DRM version: $hw_version"
    fi
    
    # 获取LCD信息
    if [ -f "/proc/lcm_id" ]; then
        lcm_id=$(cat /proc/lcm_id)
        log "LCM ID: $lcm_id"
        hw_version="$hw_version-LCM$lcm_id"
    fi
    
    # 获取触摸屏IC信息
    if [ -d "/sys/class/touchscreen" ]; then
        touch_ic=$(ls /sys/class/touchscreen/)
        log "Touch IC: $touch_ic"
        hw_version="$hw_version-TOUCH$touch_ic"
    fi
    
    echo "$hw_version"
}

# 函数：选择固件文件
select_firmware() {
    local hw_version=$1
    local firmware_config=""
    local firmware_main=""
    
    # 根据硬件版本选择固件
    case "$hw_version" in
        *LCMID33*VER0x0028*)
            firmware_config="TP-CONFIG-FW-PD1936-LCMID33-VER0x0028.bin"
            firmware_main="TP-FW-PD1936-LCMID33-VER0x502100028.bin"
            log "Selected firmware set: 0028"
            ;;
        *LCMID33*VER0x002C*)
            firmware_config="TP-CONFIG-FW-PD1936-LCMID33-VER0x002C.bin"
            firmware_main="TP-FW-PD1936-LCMID33-VER0x50213002C.bin"
            log "Selected firmware set: 002C"
            ;;
        *LCMID33*)
            # 默认选择最新版本
            firmware_config="TP-CONFIG-FW-PD1936-LCMID33-VER0x002C.bin"
            firmware_main="TP-FW-PD1936-LCMID33-VER0x50213002C.bin"
            log "Selected default firmware (LCMID33)"
            ;;
        *)
            # 通用回退方案
            if check_file "$FIRMWARE_PATH/TP-CONFIG-FW-PD1936-LCMID33-VER0x002C.bin"; then
                firmware_config="TP-CONFIG-FW-PD1936-LCMID33-VER0x002C.bin"
                firmware_main="TP-FW-PD1936-LCMID33-VER0x50213002C.bin"
                log "Selected fallback firmware (002C)"
            elif check_file "$FIRMWARE_PATH/TP-CONFIG-FW-PD1936-LCMID33-VER0x0028.bin"; then
                firmware_config="TP-CONFIG-FW-PD1936-LCMID33-VER0x0028.bin"
                firmware_main="TP-FW-PD1936-LCMID33-VER0x502100028.bin"
                log "Selected fallback firmware (0028)"
            else
                firmware_config="touch_firmwares_recovery.bin"
                firmware_main="touch_firmwares_recovery.bin"
                log "Selected generic firmware"
            fi
            ;;
    esac
    
    echo "$firmware_config:$firmware_main"
}

# 函数：复制固件到目标位置
copy_firmware() {
    local src_config=$1
    local src_main=$2
    
    # 目标位置（内核驱动期望的位置）
    local dest_config="/vendor/firmware/tp_config.bin"
    local dest_main="/vendor/firmware/tp_firmware.bin"
    
    log "Copying $src_config to $dest_config"
    cp "$FIRMWARE_PATH/$src_config" "$dest_config"
    
    log "Copying $src_main to $dest_main"
    cp "$FIRMWARE_PATH/$src_main" "$dest_main"
    
    # 设置正确的权限
    chmod 644 "$dest_config"
    chmod 644 "$dest_main"
    
    # 如果是通用固件，可能需要解包
    if [ "$src_config" = "touch_firmwares_recovery.bin" ]; then
        handle_generic_firmware "$dest_main"
    fi
}

# 函数：处理通用固件
handle_generic_firmware() {
    local firmware_file=$1
    
    log "Processing generic firmware: $firmware_file"
    
    # 检查是否是压缩或复合固件
    if file "$firmware_file" | grep -q "archive"; then
        log "Firmware appears to be an archive, attempting to extract"
        # 这里可以添加解压逻辑
        # tar -xzf "$firmware_file" -C "$FIRMWARE_PATH/"
    fi
}

# 函数：加载触摸屏驱动
load_touch_driver() {
    log "Attempting to load touchscreen driver"
    
    # 查找触摸屏驱动
    local driver_path=""
    
    # 检查常见位置
    for path in "/vendor/lib/modules/" "/system/lib/modules/" "/vendor/firmware/modules/"; do
        if [ -f "${path}touchscreen.ko" ]; then
            driver_path="${path}touchscreen.ko"
            break
        fi
        if [ -f "${path}touchscreen_driver.ko" ]; then
            driver_path="${path}touchscreen_driver.ko"
            break
        fi
    done
    
    if [ -n "$driver_path" ]; then
        log "Found touch driver: $driver_path"
        
        # 加载驱动
        insmod "$driver_path"
        
        # 检查是否加载成功
        if lsmod | grep -q "touchscreen"; then
            log "Touch driver loaded successfully"
            return 0
        else
            log "Failed to load touch driver"
            return 1
        fi
    else
        log "No touch driver found"
        return 2
    fi
}

# 函数：初始化触摸屏
init_touchscreen() {
    log "Initializing touchscreen"
    
    # 创建必要的设备节点
    if [ ! -c "/dev/input/event2" ]; then
        mknod /dev/input/event2 c 13 66
        chmod 666 /dev/input/event2
        log "Created touch device node"
    fi
    
    # 设置触摸屏参数
    if [ -f "/sys/class/touchscreen/parameters" ]; then
        echo "1" > /sys/class/touchscreen/parameters/enable
        log "Enabled touchscreen parameters"
    fi
    
    # 校准触摸屏（如果需要）
    if [ -f "/sys/class/touchscreen/calibration" ]; then
        echo "calibrate" > /sys/class/touchscreen/calibration
        sleep 1
        log "Touchscreen calibration initiated"
    fi
}

# 主执行逻辑
main() {
    log "Starting touch firmware selection"
    
    # 1. 获取硬件版本
    HW_VERSION=$(get_hardware_version)
    log "Detected hardware: $HW_VERSION"
    
    # 2. 确保固件目录存在
    mkdir -p "$FIRMWARE_PATH"
    mkdir -p "/vendor/firmware"
    
    # 3. 列出可用的固件
    log "Available firmware files:"
    ls -la "$FIRMWARE_PATH/" >> $LOG_FILE 2>&1
    
    # 4. 选择固件
    FIRMWARE_SET=$(select_firmware "$HW_VERSION")
    CONFIG_FILE=$(echo "$FIRMWARE_SET" | cut -d: -f1)
    MAIN_FILE=$(echo "$FIRMWARE_SET" | cut -d: -f2)
    
    log "Selected config: $CONFIG_FILE"
    log "Selected main: $MAIN_FILE"
    
    # 5. 检查固件文件是否存在
    if ! check_file "$FIRMWARE_PATH/$CONFIG_FILE" || ! check_file "$FIRMWARE_PATH/$MAIN_FILE"; then
        log "ERROR: Selected firmware files not found!"
        log "Falling back to generic firmware"
        CONFIG_FILE="touch_firmwares_recovery.bin"
        MAIN_FILE="touch_firmwares_recovery.bin"
    fi
    
    # 6. 复制固件
    copy_firmware "$CONFIG_FILE" "$MAIN_FILE"
    
    # 7. 加载驱动
    load_touch_driver
    
    # 8. 初始化触摸屏
    init_touchscreen
    
    # 9. 验证触摸屏
    if [ -c "/dev/input/event2" ]; then
        log "SUCCESS: Touchscreen initialized"
        echo "1" > /tmp/touchscreen_ready
    else
        log "WARNING: Touchscreen may not be working"
        echo "0" > /tmp/touchscreen_ready
    fi
    
    log "Touch firmware selection completed"
}

# 执行主函数
main

# 复制日志到持久存储（如果有）
if [ -d "/persist" ]; then
    cp $LOG_FILE /persist/tp_firmware_selector.log 2>/dev/null
fi

exit 0