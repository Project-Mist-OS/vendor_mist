# Build fingerprint
ifeq ($(BUILD_FINGERPRINT),)
BUILD_NUMBER_MIST := $(shell date -u +%H%M)
MIST_DEVICE ?= $(TARGET_DEVICE)
ifneq ($(filter OFFICIAL,$(MIST_BUILD_TYPE)),)
BUILD_SIGNATURE_KEYS := release-keys
else
BUILD_SIGNATURE_KEYS := test-keys
endif
BUILD_FINGERPRINT := $(PRODUCT_BRAND)/$(MIST_DEVICE)/$(MIST_DEVICE):$(PLATFORM_VERSION)/$(BUILD_ID)/$(BUILD_NUMBER_MIST):$(TARGET_BUILD_VARIANT)/$(BUILD_SIGNATURE_KEYS)
endif
ADDITIONAL_SYSTEM_PROPERTIES  += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)

# AOSP recovery flashing
ifeq ($(TARGET_USES_AOSP_RECOVERY),true)
ADDITIONAL_SYSTEM_PROPERTIES  += \
    persist.sys.recovery_update=true
endif

# Versioning props
ADDITIONAL_SYSTEM_PROPERTIES  += \
    org.mist.version=$(MIST_BASE_VERSION) \
    org.mist.version.display=$(MIST_VERSION) \
    org.mist.build_date=$(MIST_BUILD_DATE) \
    org.mist.build_date_utc=$(MIST_BUILD_DATE_UTC) \
    org.mist.build_type=$(MIST_BUILD_TYPE) \
    org.mist.codename=$(MIST_CODENAME) \
    ro.mist.maintainer=$(MIST_MAINTAINER)
