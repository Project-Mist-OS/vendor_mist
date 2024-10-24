# Build fingerprint
ifneq ($(BUILD_FINGERPRINT),)
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)
endif

# MistOS System Version
ADDITIONAL_SYSTEM_PROPERTIES += \
    ro.mist.build.date=$(BUILD_DATE) \
    ro.mist.device=$(MIST_BUILD) \
    ro.mist.fingerprint=$(ROM_FINGERPRINT) \
    ro.mist.version=$(MIST_VERSION) \
    ro.mist=$(MIST_VERSION)
