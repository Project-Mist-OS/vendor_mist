# Inherit mobile mini common MistOS stuff
$(call inherit-product, vendor/mist/config/common_mobile_mini.mk)

# Inherit tablet common MistOS stuff
$(call inherit-product, vendor/mist/config/tablet.mk)

$(call inherit-product, vendor/mist/config/wifionly.mk)
