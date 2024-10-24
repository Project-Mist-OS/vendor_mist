# Inherit mobile full common MistOS stuff
$(call inherit-product, vendor/mist/config/common_mobile_full.mk)

# Inherit tablet common Lineage stuff
$(call inherit-product, vendor/mist/config/tablet.mk)

$(call inherit-product, vendor/mist/config/wifionly.mk)
