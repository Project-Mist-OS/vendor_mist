# Inherit mini common Lineage stuff
$(call inherit-product, vendor/mist/config/common_mini.mk)

# Required packages
PRODUCT_PACKAGES += \
    androidx.window.extensions \
    LatinIME

$(call inherit-product, vendor/mist/config/telephony.mk)
