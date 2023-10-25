# Versioning System
MIST_BUILD_VARIANT ?= Gapps
MIST_BUILD_TYPE ?= UNOFFICIAL
MIST_CODENAME := Alpha

# MistOS Release
ifeq ($(MIST_BUILD_TYPE), OFFICIAL)

  OFFICIAL_DEVICES = $(shell cat vendor/mist/devices/mist.devices)
  FOUND_DEVICE =  $(filter $(MIST_BUILD), $(OFFICIAL_DEVICES))
    ifeq ($(FOUND_DEVICE),$(MIST_BUILD))
      MIST_BUILD_TYPE := OFFICIAL
    else
      MIST_BUILD_TYPE := UNOFFICIAL
      $(error Device is not official "$(MIST_BUILD)")
    endif
endif

# System version
TARGET_PRODUCT_SHORT := $(subst mist_,,$(MIST_BUILD_TYPE))

MIST_DATE_YEAR := $(shell date -u +%Y)
MIST_DATE_MONTH := $(shell date -u +%m)
MIST_DATE_DAY := $(shell date -u +%d)
MIST_DATE_HOUR := $(shell date -u +%H)
MIST_DATE_MINUTE := $(shell date -u +%M)
MIST_BUILD_DATE_UTC := $(shell date -d '$(MIST_DATE_YEAR)-$(MIST_DATE_MONTH)-$(MIST_DATE_DAY) $(MIST_DATE_HOUR):$(MIST_DATE_MINUTE) UTC' +%s)
MIST_BUILD_DATE := $(MIST_DATE_YEAR)$(MIST_DATE_MONTH)$(MIST_DATE_DAY)-$(MIST_DATE_HOUR)$(MIST_DATE_MINUTE)

MIST_PLATFORM_VERSION := 13.0

MISTVERSION := 1.1

ifeq ($(MIST_VANILLA), true)
MIST_VERSION := Mist-OS-v$(MISTVERSION)-$(MIST_BUILD_DATE)-$(MIST_BUILD)-$(MIST_BUILD_TYPE)-Vanilla
else
MIST_VERSION := Mist-OS-v$(MISTVERSION)-$(MIST_BUILD_DATE)-$(MIST_BUILD)-$(MIST_BUILD_TYPE)-GApps
endif
MIST_VERSION_PROP := $(PLATFORM_VERSION)
MIST_SYSTEM_DEFAULT_PROPERTIES += \
    ro.mist.version=$(MISTVERSION) \
    ro.mist.version.display=$(MIST_VERSION) \
    ro.mist.build_date=$(MIST_BUILD_DATE) \
    ro.mist.codename=$(MIST_CODENAME) \
    ro.mist.version.prop=$(MIST_VERSION_PROP) \
    ro.mist.build_date_utc=$(MIST_BUILD_DATE_UTC) \
    ro.mist.build_type=$(MIST_BUILD_TYPE)

