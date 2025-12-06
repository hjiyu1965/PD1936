#!/bin/bash

#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# ==================== 构建变量设置 ====================

# 架构设置
export TARGET_ARCH=arm64

# A/B 分区配置
export OF_AB_DEVICE=0
export OF_VIRTUAL_AB_DEVICE=0
export OF_VANILLA_BUILD=1

# ==================== OrangeFox 11 工具配置 ====================

# 构建工具
export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_GREP_BINARY=1
export FOX_USE_DATE_BINARY=1
export FOX_USE_ZIP_BINARY=1

# 压缩配置
export OF_DISABLE_LZMA=0
export OF_USE_LZMA_COMPRESSION=1
export OF_USE_LZ4_COMPRESSION=0

# ==================== 设备信息配置 ====================

# 维护者信息
export OF_MAINTAINER="YourName"
export FOX_BUILD_TYPE="Beta"
export FOX_VERSION="R11.1"
export FOX_MAINTAINER_PATCH_VERSION=1

# ==================== 显示与屏幕配置 ====================

# 屏幕分辨率 (PD1936: 1080x2400)
export OF_SCREEN_H=2400
export OF_SCREEN_W=1080
export OF_STATUS_H=144
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=1
export OF_CLOCK_POS=0

# 状态栏偏移
export TW_Y_OFFSET=80
export TW_H_OFFSET=0

# 主题和语言
export TW_THEME=portrait_hdpi
export TW_DEFAULT_LANGUAGE=zh_CN
export TW_EXTRA_LANGUAGES=true
export OF_USE_LOCKSCREEN_BUTTON=0

# ==================== 亮度配置 ====================

export TW_BRIGHTNESS_PATH=/sys/class/backlight/panel0-backlight/brightness
export TW_MAX_BRIGHTNESS=255
export TW_DEFAULT_BRIGHTNESS=160

export FOX_BRIGHTNESS_PATH=/sys/class/backlight/panel0-backlight/brightness
export FOX_MAX_BRIGHTNESS=255
export FOX_DEFAULT_BRIGHTNESS=160

# ==================== 时间与区域配置 ====================

export TW_DEFAULT_TIME_ZONE="Asia/Shanghai"

# ==================== 安全与加密配置 ====================

export OF_ADVANCED_SECURITY=0
export OF_SKIP_FBE_DECRYPTION=0
export OF_NO_RELOAD_AFTER_DECRYPTION=0

# 加密支持
export TW_INCLUDE_CRYPTO=1
export TW_INCLUDE_CRYPTO_FBE=1
export TW_INCLUDE_FBE_METADATA_DECRYPT=1
export TW_USE_FSCRYPT_POLICY=1

# OrangeFox 加密配置
export FOX_USE_FSCRYPT=1
export FOX_USE_DM_VERITY=1
export FOX_USE_AVB=1
export FOX_USE_DATA_DECRYPTION=1

# ==================== 功能配置 ====================

# LED 和闪光灯
export OF_CLASSIC_LEDS_FUNCTION=0
export OF_FLASHLIGHT_ENABLE=1

# 导航栏和按钮
export OF_ALLOW_DISABLE_NAVBAR=1
export OF_USE_UNLOCK_BUTTON=1
export OF_USE_LOCKED_BOOT=1

# ==================== 文件系统支持 ====================

export TW_INCLUDE_NTFS_3G=1
export TW_INCLUDE_FUSE_EXFAT=1
export TW_INCLUDE_FUSE_NTFS=1
export TW_INCLUDE_RESETPROP=1
export TW_INCLUDE_REPACKTOOLS=1

# F2FS 配置
export OF_UNBIND_SDCARD_F2FS=0
export OF_FORCE_DATA_FORMAT_F2FS=0
export FOX_USE_F2FS_COMPRESSION=1

# ==================== 触摸屏固件支持 ====================

export OF_SUPPORT_ALL_BLOCK_OTA_UPDATES=1
export OF_FIX_OTA_UPDATE_MANUAL_FLASH_ERROR=1
export OF_SUPPORT_TOUCH_FIRMWARE=1
export OF_FORCE_PREBUILT_KERNEL=1

# ==================== 备份配置 ====================

export OF_QUICK_BACKUP_LIST="/data;/system;/vendor;/boot;/product;/system_ext"
export TW_BACKUP_EXCLUSIONS="/data/fonts/files"

# ==================== OrangeFox 11 特定配置 ====================

# 电池信息显示
export FOX_THEME="11"
export FOX_CUSTOM_BATTERY_PERCENTAGE=1
export FOX_CUSTOM_BATTERY_CAPACITY="4000"
export FOX_CUSTOM_BATTERY_TEMP_PATH="/sys/class/power_supply/battery/temp"
export FOX_CUSTOM_BATTERY_VOLTAGE_PATH="/sys/class/power_supply/battery/voltage_now"
export FOX_CUSTOM_BATTERY_CURRENT_PATH="/sys/class/power_supply/battery/current_now"

# ==================== 构建配置 ====================

export FOX_INSTALLER_DEBUG_MODE=0
export FOX_DELETE_AROMAFM=0
export FOX_REMOVE_AAPT=0
export FOX_DYNAMIC_SAMSUNG_FIX=0
export OF_MANUAL_ROOT_VENDOR_ERROR_FIX=0

# ==================== 设备特定配置 ====================

export FOX_DEVICE_MODEL="V1936A"
export FOX_DEVICE_BRAND="vivo"
export FOX_DEVICE_NAME="PD1936"

# ==================== OrangeFox 11 杂项配置 ====================

# 工具排除配置
export FOX_EXCLUDE_NANO_EDITOR=0
export FOX_EXCLUDE_BASH_SHELL=0
export FOX_EXCLUDE_TAR_BINARY=0
export FOX_EXCLUDE_ZIP_BINARY=0
export FOX_EXCLUDE_XZ_UTILS=0
export FOX_EXCLUDE_SED_BINARY=0
export FOX_EXCLUDE_GREP_BINARY=0

# 日志配置
export FOX_INCLUDE_LOG=1
export FOX_LOG_PATH="/tmp/recovery.log"

# 系统属性
export FOX_USE_SYSTEM_PROPS=1

# 其他配置
export OF_NO_SPLASH_CHANGE=0
export OF_REPORT_HARMLESS_MOUNT_ISSUES=0
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1

# ==================== 设备特定路径配置 ====================

# 分区路径（根据实际设备调整）
export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/by-name/recovery"
export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/by-name/system"
export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/by-name/vendor"
export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"
export FOX_RECOVERY_PRODUCT_PARTITION="/dev/block/by-name/product"
export FOX_RECOVERY_SYSTEM_EXT_PARTITION="/dev/block/by-name/system_ext"

# ==================== 解密配置 ====================

export OF_DEFAULT_KEYMASTER_VERSION="4.0"
export OF_NO_KEYMASTER_VER_4X=0

# ==================== 构建系统提示 ====================

# 重要提示：OrangeFox 构建系统会自动处理设备选择
# 不要在 vendorsetup.sh 中使用 lunch_combo 命令
# 系统会自动调用 lunch_combo omni_PD1936-eng 或类似命令

echo "[OrangeFox] 为 PD1936 (vivo V1936A) 配置 OrangeFox R11.1"
echo "[OrangeFox] 维护者: YourName"
echo "[OrangeFox] 构建类型: Beta"
echo "[OrangeFox] 屏幕: 1080x2400"
echo "[OrangeFox] 架构: arm64"
