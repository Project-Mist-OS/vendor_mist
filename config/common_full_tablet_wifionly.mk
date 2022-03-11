# Inherit full common MistOS stuff
$(call inherit-product, vendor/mist/config/common_full.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
