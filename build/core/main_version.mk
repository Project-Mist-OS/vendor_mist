# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# MistOS System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.mist.version=$(MIST_VERSION) \
    ro.mist.display.version=$(MIST_DISPLAY_VERSION) \
    ro.mist.releasetype=$(MIST_BUILDTYPE) \
    ro.mist.build.version=$(MIST_PLATFORM_VERSION) \
    ro.modversion=$(MIST_VERSION) \
