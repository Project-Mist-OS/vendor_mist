MIST_DATE_YEAR := $(shell date -u +%Y)
MIST_DATE_MONTH := $(shell date -u +%m)
MIST_DATE_DAY := $(shell date -u +%d)
MIST_DATE_HOUR := $(shell date -u +%H)
MIST_DATE_MINUTE := $(shell date -u +%M)
MIST_BUILD_DATE_UTC := $(shell date -d '$(MIST_DATE_YEAR)-$(MIST_DATE_MONTH)-$(MIST_DATE_DAY) $(MIST_DATE_HOUR):$(MIST_DATE_MINUTE) UTC' +%s)
MIST_BUILD_DATE := $(MIST_DATE_YEAR)$(MIST_DATE_MONTH)$(MIST_DATE_DAY)-$(MIST_DATE_HOUR)$(MIST_DATE_MINUTE)

MIST_DISPLAY_VERSION := 3.0
MIST_PLATFORM_VERSION := 15.0

MIST_VERSION := v$(MIST_DISPLAY_VERSION)-$(MIST_BUILD)-$(MIST_PLATFORM_VERSION)-$(MIST_BUILD_DATE)

# MistOS Platform Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.mist.build.date=$(BUILD_DATE) \
    ro.mist.device=$(MIST_BUILD) \
    ro.mist.fingerprint=$(ROM_FINGERPRINT) \
    ro.mist.version=$(MIST_VERSION) \
    ro.modversion=$(MIST_VERSION)

# Signing
-include vendor/mist-priv/keys/keys.mk
