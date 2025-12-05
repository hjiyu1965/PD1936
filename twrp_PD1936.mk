#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common OrangeFox configurations.
$(call inherit-product, vendor/fox/config/common.mk)

# Inherit from PD1936 device
$(call inherit-product, device/vivo/PD1936/device.mk)

PRODUCT_DEVICE := PD1936
PRODUCT_NAME := twrp_PD1936
PRODUCT_BRAND := vivo
PRODUCT_MODEL := V1936A
PRODUCT_MANUFACTURER := vivo

PRODUCT_GMS_CLIENTID_BASE := android-11

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=PD1936 \
    PRODUCT_NAME=PD1936 \
    PRIVATE_BUILD_DESC="PD1936-user 11 RP1A.200720.012 compiler0714182446 release-keys"

BUILD_FINGERPRINT := vivo/PD1936/PD1936:11/RP1A.200720.012/compiler0714182446:user/release-keys

# OrangeFox specific properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.orangefox.device=$(PRODUCT_DEVICE) \
    ro.orangefox.version=$(FOX_VERSION) \
    ro.orangefox.build_type=$(FOX_BUILD_TYPE) \
    ro.orangefox.maintainer=$(FOX_MAINTAINER)
