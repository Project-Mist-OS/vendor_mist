# Inherit common mist stuff
$(call inherit-product, vendor/mist/config/common_mobile.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
