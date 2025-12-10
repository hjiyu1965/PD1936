#!/bin/bash

# OrangeFox Recovery 构建变量配置
# 设备：vivo PD1936
# 平台：msmnile
# 架构：arm64

# 基本架构配置（已由 BoardConfig.mk 设置，此处可省略）
# export TARGET_ARCH=arm64

# A/B 设备标识 - PD1936 不是 A/B 设备
export FOX_AB_DEVICE=0
export OF_AB_DEVICE_WITH_RECOVERY_PARTITION=0

# 使用预编译内核
export OF_FORCE_PREBUILT_KERNEL=1

# 恢复分区设置（使用默认值，无需修改）
# export FOX_RECOVERY_INSTALL_PARTITION="/dev/block/by-name/recovery"

# 屏幕参数配置（根据设备实际情况调整）
# PD1936 可能使用 19.5:9 或 20:9 屏幕
# export OF_SCREEN_H=2340  # 19.5*120
# export OF_SCREEN_H=2400  # 20*120

# 状态栏高度（如果有刘海）
# export OF_STATUS_H=144

# 状态栏左右缩进（圆角屏幕）
# export OF_STATUS_INDENT_LEFT=48
# export OF_STATUS_INDENT_RIGHT=48

# 隐藏刘海选项
# export OF_HIDE_NOTCH=1

# 时钟位置选项
# export OF_CLOCK_POS=0

# 维护者信息
export OF_MAINTAINER="hjiyu1965"
export FOX_MAINTAINER_PATCH_VERSION=1

# 主题设置
export TW_THEME="portrait_hdpi"

# 语言支持
export TW_EXTRA_LANGUAGES=true

# 加密支持
export TW_INCLUDE_CRYPTO=true
export TW_INCLUDE_CRYPTO_FBE=true

# 屏幕亮度
export TW_MAX_BRIGHTNESS=255
export TW_DEFAULT_BRIGHTNESS=128

# 设备标识
export TW_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID=true

# 工具配置
export TW_USE_TOOLBOX=true

# 禁用导航栏（如果设备有硬件按键）
# export OF_ALLOW_DISABLE_NAVBAR=0

# 手电筒功能
export OF_FLASHLIGHT_ENABLE=1

# 安全补丁绕过
export PLATFORM_SECURITY_PATCH="2099-12-31"
export PLATFORM_VERSION="16.1.0"

# 恢复设置不重置
export FOX_RESET_SETTINGS="disabled"

# 高级安全功能
export OF_ADVANCED_SECURITY=1

# 日志保留
export OF_DONT_KEEP_LOG_HISTORY=0

# 禁用MIUI特定功能（非小米设备）
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1
export OF_TWRP_COMPATIBILITY_MODE=1
export FOX_VANILLA_BUILD=1

# 快速备份分区列表
export OF_QUICK_BACKUP_LIST="/data;/system;/vendor;/boot;"

# 跳过FBE解密（如果在OrangeFox图标处卡住）
# export OF_SKIP_FBE_DECRYPTION=1

# 指定Android版本跳过解密
# export OF_SKIP_FBE_DECRYPTION_SDKVERSION=31

# 二进制工具（根据需要添加，会增加镜像大小）
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_GREP_BINARY=0
export FOX_USE_BASH_SHELL=1
export FOX_ASH_IS_BASH=1
export FOX_USE_XZ_UTILS=0
export FOX_USE_NANO_EDITOR=0

# 使用busybox二进制
export FOX_USE_BUSYBOX_BINARY=1

# 压缩可执行文件（减小镜像大小）
export FOX_COMPRESS_EXECUTABLES=1

# 强制使用recovery fstab（如果解密失败）
# export OF_FORCE_USE_RECOVERY_FSTAB=1

# 默认时区
export OF_DEFAULT_TIMEZONE="CET-1;CEST,M3.5.0,M10.5.0"

# 禁用MIUI额外属性检查
export OF_NO_ADDITIONAL_MIUI_PROPS_CHECK=1

# 电池服务（如果百分比显示异常）
# export OF_USE_LEGACY_BATTERY_SERVICES=1

# AVB 2.0 修补
export OF_PATCH_AVB20=1

# 禁用开机动画更改（如果有问题）
# export OF_NO_SPLASH_CHANGE=1

# 移除AromaFM（如果无法工作）
# export FOX_DELETE_AROMAFM=1

# 跳过预编译内核模块加载
export OF_SKIP_PREBUILT_MODULES=1

# 设备没有persist分区（如果有）
# export OF_DEVICE_WITHOUT_PERSIST=1

# 启用早期设置加载
export FOX_ALLOW_EARLY_SETTINGS_LOAD=1

# 跳过已解密的适配存储
export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1

# 数据格式化后卸载SD卡
export OF_UNMOUNT_SDCARDS_BEFORE_REBOOT=1

# 打印构建信息
echo "[OrangeFox] 构建变量已设置 for PD1936"
echo "[OrangeFox] 维护者: $OF_MAINTAINER"
echo "[OrangeFox] 版本补丁: $FOX_MAINTAINER_PATCH_VERSION"
