ifneq ($(filter OFFICIAL CI,$(MIST_BUILD_TYPE)),)
PRODUCT_PACKAGES += \
    Updates
endif
