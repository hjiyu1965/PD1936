# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/vivo/PD1936

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# -----------------------------------------------------------------------------
# Architecture
# -----------------------------------------------------------------------------
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

# 2nd (32-bit) arch (if device boots a 32-bit userspace)
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

# -----------------------------------------------------------------------------
# APEX
# -----------------------------------------------------------------------------
OVERRIDE_TARGET_FLATTEN_APEX := true

# -----------------------------------------------------------------------------
# Bootloader / Platform
# -----------------------------------------------------------------------------
TARGET_BOOTLOADER_BOARD_NAME := msmnile
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := msmnile

# -----------------------------------------------------------------------------
# Display
# -----------------------------------------------------------------------------
TARGET_SCREEN_DENSITY := 480
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 2400

# -----------------------------------------------------------------------------
# Kernel configuration
# -----------------------------------------------------------------------------
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x80000000

# NOTE: Replace the following cmdline with the full kernel cmdline used on device.
# The original file had an ellipsis; avoid truncating the cmdline.
BOARD_KERNEL_CMDLINE := console=null earlycon=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator=...

BOARD_KERNEL_PAGESIZE := 4096
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_KERNEL_IMAGE_NAME := Image
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_KERNEL_SEPARATED_DTBO := true

# If building kernel from source, set these:
TARGET_KERNEL_CONFIG := PD1936_defconfig
TARGET_KERNEL_SOURCE := kernel/vivo/PD1936

# -----------------------------------------------------------------------------
# Kernel - prebuilt option
# -----------------------------------------------------------------------------
# Choose either to build kernel (leave TARGET_FORCE_PREBUILT_KERNEL=false) or
# use a prebuilt kernel (set to true and provide TARGET_PREBUILT_KERNEL).
# Using both is confusing; prefer one approach.
TARGET_FORCE_PREBUILT_KERNEL := false
ifeq ($(TARGET_FORCE_PREBUILT_KERNEL),true)
  TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
  TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
  BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)
  BOARD_INCLUDE_DTB_IN_BOOTIMG := false
  BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
  BOARD_KERNEL_SEPARATED_DTBO := false
  # If you set FORCE_PREBUILT, consider unsetting TARGET_KERNEL_SOURCE and
  # TARGET_KERNEL_CONFIG to avoid accidental rebuilds.
endif

# -----------------------------------------------------------------------------
# Partitions
# -----------------------------------------------------------------------------
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 100663296
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# -----------------------------------------------------------------------------
# Recovery / TWRP
# -----------------------------------------------------------------------------
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := hbtp_vm
TW_USE_TOOLBOX := true

# TWRP Features
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_CRYPTO_METADATA := true
TW_INCLUDE_FUSE := true
TW_INCLUDE_EXFAT := true
TW_INCLUDE_NTFS := true
TW_INCLUDE_ASHMEM := true
TW_INCLUDE_PSTORE := true
TW_INCLUDE_LOGCAT := true
TW_INCLUDE_GREP := true
TW_INCLUDE_SHA1SUM := true
TW_INCLUDE_SHA256SUM := true
TW_INCLUDE_CRYPTFS := true
TW_ALLOW_FLASH_RAW := true

# Decrypt /data
TW_INCLUDE_FBE_METADATA_DECRYPT := true
TW_INCLUDE_KEYMASTER_HAL := true
TW_USE_FSCRYPT := true
TW_CRYPTO_FS_TYPE := f2fs
# -----------------------------------------------------------------------------
# Verified Boot / AVB
# -----------------------------------------------------------------------------
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Required for non-A/B devices
BOARD_AVB_RECOVERY_ALGORITHM := sha256_rsa2048
BOARD_AVB_RECOVERY_HASH := $(BOARD_AVB_RECOVERY_KEY_PATH)
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := 1
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Vendor / security patch
VENDOR_SECURITY_PATCH := 2021-08-01

# -----------------------------------------------------------------------------
# NOTE: Avoid hacks that set platform/vendor patch levels to a far future date.
# Setting PLATFORM_SECURITY_PATCH := 2099-12-31 is dangerous and will alter
# verified-boot expectations. If you used that to bypass anti-rollback, consider:
#  - disabling AVB for recovery builds, or
#  - using properly generated vbmeta with --prop from your build artifacts.
# -----------------------------------------------------------------------------
# PLATFORM_SECURITY_PATCH := 2099-12-31   # <-- commented out on purpose
# VENDOR_SECURITY_PATCH := 2099-12-31     # <-- do not set to far-future values
# PLATFORM_VERSION := 16.1.0