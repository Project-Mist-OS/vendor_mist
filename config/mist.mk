# PIF values
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.pihooks_MANUFACTURER?=Google \
    persist.sys.pihooks_BRAND?=google \
    persist.sys.pihooks_PRODUCT?=comet_beta \
    persist.sys.pihooks_DEVICE?=comet \
    persist.sys.pihooks_ID?=BP41.250916.010.A1 \
    persist.sys.pihooks_RELEASE?=12 \
    persist.sys.pihooks_SECURITY_PATCH?=2025-10-05 \
    persist.sys.pihooks_DEVICE_INITIAL_SDK_INT?=21 \
    persist.sys.pihooks_SDK_INT?=32

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildFingerprint=google/comet_beta/comet:16/BP41.250916.010.A1/14281945:user/release-keys \
    PihooksGmsFp="google/comet_beta/comet:16/BP41.250916.010.A1/14281945:user/release-keys" \
    PihooksGmsModel="Pixel 9 Pro Fold"

# GMS
WITH_GMS ?= false
ifeq ($(WITH_GMS),true)
  ifeq ($(TARGET_USES_MINI_GAPPS),true)
    $(call inherit-product, vendor/gms/gms_mini.mk)
  else
    ifeq ($(TARGET_USES_PICO_GAPPS),true)
      $(call inherit-product, vendor/gms/gms_pico.mk)
  else
      $(call inherit-product, vendor/gms/gms_full.mk)
    endif
  endif
endif

# Extra packages
PRODUCT_PACKAGES += \
    CertifiedKeyboxOverlay \
    GameSpace \
    OmniJaws \
    OmniStyle

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# Updater
ifeq ($(MIST_BUILD_TYPE),OFFICIAL)
PRODUCT_PACKAGES += \
    Updater
endif

# Enable blur
TARGET_ENABLE_BLUR ?= true
ifeq ($(TARGET_ENABLE_BLUR),true)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=true \
    persist.sysui.disableBlur=false \
    ro.surface_flinger.supports_background_blur=1
else
PRODUCT_SYSTEM_PROPERTIES += \
    ro.custom.blur.enable=false \
    persist.sysui.disableBlur=true \
    ro.surface_flinger.supports_background_blur=0
endif

# Face Unlock
ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/android.hardware.biometrics.face.xml
endif

# DeviceAsWebcam
ifeq ($(TARGET_BUILD_DEVICE_AS_WEBCAM), true)
    PRODUCT_PACKAGES += \
        DeviceAsWebcam

    PRODUCT_VENDOR_PROPERTIES += \
        ro.usb.uvc.enabled=true
endif

# ColumbusService
ifneq ($(TARGET_SUPPORTS_QUICK_TAP),false)
PRODUCT_PACKAGES += \
    ColumbusService
endif

# Disable async MTE on a few processes
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.app.com.android.se=off \
    persist.arm64.memtag.app.com.google.android.bluetooth=off \
    persist.arm64.memtag.app.com.android.nfc=off \
    persist.arm64.memtag.process.system_server=off

# Other ROM feature flags
BYPASS_CHARGE_SUPPORTED ?= false
PERF_ANIM_OVERRIDE ?= false
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.activity_anim_perf_override=$(PERF_ANIM_OVERRIDE)
    persist.sys.battery_bypass_supported=$(BYPASS_CHARGE_SUPPORTED)

# Quick Switch
TARGET_DEFAULT_PIXEL_LAUNCHER ?= false
ifeq ($(WITH_GMS),true)
ifeq ($(TARGET_DEFAULT_PIXEL_LAUNCHER), true)
# Pixel Launcher
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.default_launcher=1 \
    persist.sys.quickswitch_pixel_shipped=1
else
# Launcher3
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.default_launcher=0 \
    persist.sys.quickswitch_pixel_shipped=1
endif
else
PRODUCT_SYSTEM_PROPERTIES += \
    persist.sys.default_launcher=0
endif
