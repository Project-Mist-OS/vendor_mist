# Inherit common mobile MistOS stuff
$(call inherit-product, vendor/mist/config/common.mk)

# Apps
PRODUCT_PACKAGES += \
    LatinIME

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
