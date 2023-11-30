$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Inherit common mistOS stuff
$(call inherit-product, vendor/mist/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
