#!/bin/bash

# 基本架构
export TARGET_ARCH=arm64
export FOX_AB_DEVICE=0

# 1. 首先尝试最简单的解密跳过
export OF_SKIP_FBE_DECRYPTION=1

# 2. 强制使用恢复fstab
export OF_FORCE_USE_RECOVERY_FSTAB=1

# 3. 修复解密问题
export OF_FIX_DECRYPTION_ON_DATA_MEDIA=1

# 4. 禁用MIUI功能（非小米设备）
export FOX_VANILLA_BUILD=1
export OF_DISABLE_MIUI_SPECIFIC_FEATURES=1

# 5. 简化构建，减少二进制文件
export FOX_USE_TAR_BINARY=0
export FOX_USE_SED_BINARY=0
export FOX_USE_BASH_SHELL=0
export FOX_USE_NANO_EDITOR=0
export FOX_USE_BUSYBOX_BINARY=1  # 只保留busybox

# 6. 压缩可执行文件以减小体积
export FOX_COMPRESS_EXECUTABLES=1

# 7. 跳过预编译模块
export OF_SKIP_PREBUILT_MODULES=1

# 8. 屏幕参数（使用默认值，先不自定义）
# export OF_SCREEN_H=1920  # 先注释掉
# export OF_STATUS_H=72    # 先注释掉

# 9. 禁用高级安全功能（可能导致卡屏）
export OF_ADVANCED_SECURITY=0

# 10. 允许早期设置加载
export FOX_ALLOW_EARLY_SETTINGS_LOAD=1

# 11. 跳过已解密的适配存储
export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1

# 12. 维护者信息（纯数字）
export OF_MAINTAINER="YourName"
# export FOX_MAINTAINER_PATCH_VERSION=1  # 先注释掉，避免错误

echo "[OrangeFox] 应用卡屏修复配置"
