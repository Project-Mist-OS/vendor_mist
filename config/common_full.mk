# Inherit common Lineage stuff
$(call inherit-product, vendor/mist/config/common_mobile.mk)

PRODUCT_SIZE := full

# Include {Lato,Rubik} fonts
$(call inherit-product-if-exists, external/google-fonts/lato/fonts.mk)
$(call inherit-product-if-exists, external/google-fonts/rubik/fonts.mk)

# Extra cmdline tools
PRODUCT_PACKAGES += \
    unrar \
    zstd
