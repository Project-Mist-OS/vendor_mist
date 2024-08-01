# Inherit common mobile Mist stuff
$(call inherit-product, vendor/mist/config/common.mk)

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

ifneq ($(WITH_MIST_CHARGER),false)
PRODUCT_PACKAGES += \
    mist_charger_animation \
    mist_charger_animation_vendor
endif

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# SystemUI plugins
PRODUCT_PACKAGES += \
    QuickAccessWallet
