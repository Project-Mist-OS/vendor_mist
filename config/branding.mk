# Copyright (C) 2018-23 The MistOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Mist OS Versioning :
MIST_MOD_VERSION = Fourteen-Alpha

ifndef MIST_BUILD_TYPE
    MIST_BUILD_TYPE := COMMUNITY
endif

# Test Build Tag
ifeq ($(MIST_TEST),true)
    MIST_BUILD_TYPE := DEVELOPER
endif

CURRENT_DEVICE=$(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
MIST_BUILD_DATE_UTC := $(shell date -u '+%Y%m%d-%H%M')
BUILD_DATE_TIME := $(shell date -u '+%Y%m%d%H%M')

ifeq ($(MIST_OFFICIAL), true)
   LIST = $(shell cat vendor/mist/mist.devices)
    ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
      IS_OFFICIAL=true
      MIST_BUILD_TYPE := RELEASE

#include vendor/mist-priv/keys.mk
PRODUCT_PACKAGES += \
    Updater

    endif
    ifneq ($(IS_OFFICIAL), true)
       MIST_BUILD_TYPE := COMMUNITY
       $(error Device is not official "$(CURRENT_DEVICE)")
    endif
endif

ifeq ($(BUILD_WITH_GAPPS),true)
MIST_EDITION := GAPPS
else
MIST_EDITION := Vanilla
endif

ifeq ($(MIST_EDITION), GAPPS)
MIST_VERSION := MistOS-$(MIST_MOD_VERSION)-$(CURRENT_DEVICE)-$(MIST_EDITION)-$(MIST_BUILD_TYPE)-$(MIST_BUILD_DATE_UTC)
MIST_FINGERPRINT := MistOS/$(MIST_MOD_VERSION)/$(PLATFORM_VERSION)/$(MIST_BUILD_DATE_UTC)
MIST_DISPLAY_VERSION := MistOS-$(MIST_MOD_VERSION)-$(MIST_BUILD_TYPE)
else
MIST_VERSION := MistOS-$(MIST_MOD_VERSION)-$(CURRENT_DEVICE)-$(MIST_BUILD_TYPE)-$(MIST_BUILD_DATE_UTC)
MIST_FINGERPRINT := MistOS/$(MIST_MOD_VERSION)/$(PLATFORM_VERSION)/$(MIST_BUILD_DATE_UTC)
MIST_DISPLAY_VERSION := MistOS-$(MIST_MOD_VERSION)-$(MIST_BUILD_TYPE)
endif

TARGET_PRODUCT_SHORT := $(subst mist_,,$(MIST_BUILD))

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.mist.version=$(MIST_VERSION) \
  ro.mist.releasetype=$(MIST_BUILD_TYPE) \
  ro.modversion=$(MIST_MOD_VERSION) \
  ro.mist.display.version=$(MIST_DISPLAY_VERSION) \
  ro.mist.fingerprint=$(MIST_FINGERPRINT) \
  ro.build.datetime=$(BUILD_DATE_TIME) \
  ro.mist.edition=$(MIST_EDITION)
