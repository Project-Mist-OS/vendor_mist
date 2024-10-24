# Set Lineage specific identifier for Android Go enabled products
PRODUCT_TYPE := go

# Inherit full common MistOs stuff
$(call inherit-product, vendor/mist/config/common_full_phone.mk)
