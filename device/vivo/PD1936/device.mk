# Minimal device makefile for vivo PD1936
# Place this file at device/vivo/PD1936/device.mk

LOCAL_PATH := $(call my-dir)

# Ensure the device name is known to the build system (minimal required)
PRODUCT_DEVICE := PD1936

# If you want, add device-specific PRODUCT_PACKAGES or other variables here.
# Example placeholders (uncomment and fill if needed):
# PRODUCT_BRAND := vivo
# PRODUCT_MANUFACTURER := vivo
# PRODUCT_NAME := PD1936

# Include any device-specific makefiles in this directory
include $(call all-subdir-makefiles,$(LOCAL_PATH))
