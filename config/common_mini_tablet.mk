# Inherit mini common Lineage stuff
$(call inherit-product, vendor/mist/config/common_mini.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/mist/config/telephony.mk)
