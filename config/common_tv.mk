# Inherit common Mist stuff
$(call inherit-product, vendor/mist/config/common.mk)

# Inherit Mist atv device tree
$(call inherit-product, device/mist/atv/mist_atv.mk)

# AOSP packages
PRODUCT_PACKAGES += \
    LeanbackIME

# Lineage packages
PRODUCT_PACKAGES += \
    LineageCustomizer

PRODUCT_PACKAGE_OVERLAYS += vendor/mist/overlay/tv
