$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit full common mist stuff
$(call inherit-product, vendor/mist/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/mist/overlay/dictionaries

$(call inherit-product, vendor/mist/config/telephony.mk)
