# Inherit full common Lineage stuff
$(call inherit-product, vendor/mist/config/common_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Mist LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/mist/overlay/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/mist/overlay/dictionaries
