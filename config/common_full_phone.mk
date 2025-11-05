# Inherit mobile full common Lineage stuff
$(call inherit-product, vendor/lineage/config/common_mobile_full.mk)

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

$(call inherit-product, vendor/lineage/config/telephony.mk)

# GMS
WITH_GMS ?= true
ifeq ($(WITH_GMS),true)
  ifeq ($(TARGET_USES_MINI_GAPPS),true)
    $(call inherit-product, vendor/gms/gms_mini.mk)
    $(call inherit-product, vendor/pixel-style/config/common.mk)
    MIST_PACKAGE_TYPE := MINI
  else ifeq ($(TARGET_USES_PICO_GAPPS),true)
    $(call inherit-product, vendor/gms/gms_pico.mk)
    $(call inherit-product, vendor/pixel-style/config/common.mk)
    MIST_PACKAGE_TYPE := PICO
  else
    $(call inherit-product, vendor/gms/gms_full.mk)
    $(call inherit-product, vendor/pixel-style/config/common.mk)
    MIST_PACKAGE_TYPE := GApps
  endif
else
    MIST_PACKAGE_TYPE := Vanilla
endif
