#
# Copyright (C) 2026 The Android Open Source Project
# Copyright (C) 2026 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),PD1936)
include $(call all-subdir-makefiles,$(LOCAL_PATH))

# Copy prebuilt kernel dtb to output directory
# This satisfies ninja dependency since all kernel components are prebuilt
$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr:
	@mkdir -p $(dir $@)
	@touch $@

# Copy prebuilt dtb.img - required for mkbootimg --dtb argument
$(PRODUCT_OUT)/dtb.img: $(LOCAL_PATH)/prebuilt/dtb.img
	@mkdir -p $(dir $@)
	@cp $< $@
	@echo "Copied prebuilt dtb.img to $@"

endif