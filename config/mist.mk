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

# Cloned app exemption
PRODUCT_COPY_FILES += \
    vendor/lineage/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-mist-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-mist-product.xml

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
