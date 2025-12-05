#!/bin/bash

#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# 设置构建变量
export TARGET_ARCH=arm64

# A/B 分区配置
export FOX_AB_DEVICE=0
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=0
export FOX_VIRTUAL_AB_DEVICE=0

# 工具配置
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_GREP_BINARY=1
export FOX_USE_DATE_BINARY=1

# 压缩配置
export OF_USE_LZMA_COMPRESSION=0
export OF_USE_LZ4_COMPRESSION=0

# 设备配置
export OF_MAINTAINER="YourName"
export FOX_MAINTAINER_PATCH_VERSION=1  # 注意：这里去掉了引号，使用整数值

# 屏幕配置（PD1936 分辨率 1080x2400，20:9 比例）
export OF_SCREEN_H=2400
export OF_SCREEN_W=1080
export OF_STATUS_H=144
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_HIDE_NOTCH=1
export OF_CLOCK_POS=0

# TWRP 主题
export TW_THEME=portrait_hdpi

# 安全配置
export OF_ADVANCED_SECURITY=0
export OF_SKIP_FBE_DECRYPTION=0
export OF_NO_RELOAD_AFTER_DECRYPTION=0

# 功能配置
export OF_CLASSIC_LEDS_FUNCTION=0
export OF_FLASHLIGHT_ENABLE=1
export OF_USE_LOCKSCREEN_BUTTON=0
export OF_ALLOW_DISABLE_NAVBAR=1

# MIUI 相关配置（非小米设备）
export OF_TWRP_COMPATIBILITY_MODE=1
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1
export FOX_VANILLA_BUILD=1

# 其他配置
export OF_DONT_KEEP_LOG_HISTORY=0
export OF_DEVICE_WITHOUT_PERSIST=0
export OF_DISABLE_EXTRA_ABOUT_PAGE=0
export OF_NO_SPLASH_CHANGE=0
export OF_REPORT_HARMLESS_MOUNT_ISSUES=0
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1

# 分区配置
export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/by-name/recovery"
export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/by-name/system"
export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/by-name/vendor"
export FOX_RECOVERY_BOOT_PARTITION="/dev/block/by-name/boot"

# 备份配置
export OF_QUICK_BACKUP_LIST="/data;/system;/vendor;/boot;"

# 触摸屏固件支持
export OF_SUPPORT_TOUCH_FIRMWARE=1
export OF_FORCE_PREBUILT_KERNEL=1

# 解密配置
export OF_DEFAULT_KEYMASTER_VERSION="4.0"
export OF_NO_KEYMASTER_VER_4X=0

# 文件系统配置
export OF_UNBIND_SDCARD_F2FS=0
export OF_FORCE_DATA_FORMAT_F2FS=0
export OF_USE_DMCTL=0

# 构建配置
export FOX_INSTALLER_DEBUG_MODE=0
export FOX_DELETE_AROMAFM=0
export FOX_REMOVE_AAPT=0
export FOX_DYNAMIC_SAMSUNG_FIX=0
export OF_MANUAL_ROOT_VENDOR_ERROR_FIX=0

# 启动配置
lunch_combo twrp_PD1936-eng
