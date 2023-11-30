ifneq ($(filter OFFICIAL CI,$(MIST_BUILD_TYPE)),)
PRODUCT_PACKAGES += \
    Updater
endif
