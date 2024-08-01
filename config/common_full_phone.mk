# Inherit full common Mist stuff
$(call inherit-product, vendor/mist/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Mist LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/mist/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/mist/overlay/dictionaries

$(call inherit-product, vendor/mist/config/telephony.mk)
