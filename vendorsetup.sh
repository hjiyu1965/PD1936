# TWRP 11 for vivo PD1936
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 SebaUbuntu's TWRP device tree generator

# 设置设备变量
export DEVICE="PD1936"
export DEVICE_BRAND="vivo"
export DEVICE_MANUFACTURER="vivo"
export DEVICE_PATH="device/vivo/PD1936"

# TWRP 构建配置
export ALLOW_MISSING_DEPENDENCIES=true
# 移除 LC_ALL="C" 设置以允许本地化支持
export RECOVERY_VARIANT="twrp"
export TARGET_RECOVERY_IS_MULTI_BOOT=false

# TWRP 版本信息
export TW_DEVICE_VERSION="1"
export TW_MAINTAINER="YourName"
export TW_DEFAULT_LANGUAGE="zh_CN"

# 添加中文支持相关配置
export TW_EXTRA_LANGUAGES=true

# Android 11 特定配置
export PLATFORM_SECURITY_PATCH="2099-12-31"
export PLATFORM_VERSION="16.1.0"
export BUILD_ID="RP1A.200720.012"

# 分区配置（适配 vivo PD1936）
export BOARD_USES_METADATA_PARTITION="true"
export BOARD_BUILD_SYSTEM_ROOT_IMAGE="true"
export BOARD_AVB_ENABLE="true"

# AVB 配置
export BOARD_AVB_RECOVERY_KEY_PATH="external/avb/test/data/testkey_rsa2048.pem"
export BOARD_AVB_RECOVERY_ALGORITHM="SHA256_RSA2048"
export BOARD_AVB_RECOVERY_ROLLBACK_INDEX="1"
export BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION="1"

# 屏幕和触摸配置（基于 BoardConfig.mk）
export TW_THEME="portrait_hdpi"
export TW_Y_OFFSET="80"
export TW_H_OFFSET="-80"
export TW_BRIGHTNESS_PATH="/sys/class/backlight/panel0-backlight/brightness"
export TW_MAX_BRIGHTNESS="1023"
export TW_DEFAULT_BRIGHTNESS="420"
export TW_TOUCHSCREEN_PEN="true"
export TW_SUPPORT_INPUT_AIDL_EVDEV="true"

# 电池和温度监控
export TW_CUSTOM_CPU_TEMP_PATH="/sys/class/thermal/thermal_zone56/temp"
export TW_CUSTOM_BATTERY_PATH="/sys/class/power_supply/battery"

# 文件系统支持
export TW_INCLUDE_NTFS_3G="true"
export TW_INCLUDE_EXFAT="true"
export TW_NO_USB_STORAGE="false"

# 加密支持（Android 11/Q）
export TW_INCLUDE_CRYPTO="true"
export TW_INCLUDE_FBE="true"
export TW_INCLUDE_FBE_METADATA_DECRYPT="true"

# 构建优化
export TW_EXCLUDE_TWRPAPP="true"
export TW_NO_SCREEN_BLANK="true"
export TW_NO_SCREEN_TIMEOUT="true"
export TW_USE_TOOLBOX="true"
export TW_INCLUDE_REPACKTOOLS="true"

# 解决data分区格式化问题
export TW_DATA_PARTION_DISABLE_ENCRYPTION_SECTORS_PATCH="true"

# 添加构建目标到 lunch 菜单
add_lunch_combo twrp_${DEVICE}-eng
add_lunch_combo twrp_${DEVICE}-userdebug

# 可选：添加 omni 构建目标（兼容旧脚本）
add_lunch_combo omni_${DEVICE}-eng
add_lunch_combo omni_${DEVICE}-userdebug

echo ""
echo "TWRP 11 for ${DEVICE_BRAND} ${DEVICE} configured."
echo "Available build targets:"
echo "  twrp_${DEVICE}-eng"
echo "  twrp_${DEVICE}-userdebug"
echo ""