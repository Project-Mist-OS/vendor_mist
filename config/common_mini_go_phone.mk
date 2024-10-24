# Set Lineage specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit mini common MistOS stuff
$(call inherit-product, vendor/mist/config/common_mini_phone.mk)
