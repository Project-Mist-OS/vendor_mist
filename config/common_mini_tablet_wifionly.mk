$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit mini common mist stuff
$(call inherit-product, vendor/mist/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
