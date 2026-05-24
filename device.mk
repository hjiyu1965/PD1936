#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/vivo/PD1936

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# API
PRODUCT_SHIPPING_API_LEVEL := 29

# Qualcomm
PRODUCT_USE_QCOM_COMMON := true

# Inherit from our custom product configuration
PRODUCT_PACKAGES += \
    libion \
    libfuse

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl

# QCOM Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.3-service

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Keystore
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0

# Copy fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/etc/recovery.fstab
