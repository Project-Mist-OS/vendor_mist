# Copyright (C) 2016-2017 AOSiP
# Copyright (C) 2020 Fluid
# Copyright (C) 2021 MistOS
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

# Versioning System
MIST_CODENAME := NAMCHE
MIST_NUM_VER := 1.0

TARGET_PRODUCT_SHORT := $(subst mist_,,$(MIST_BUILD_TYPE))

MIST_BUILD_TYPE ?= UNOFFICIAL

# Only include Updater for official  build
ifeq ($(filter-out OFFICIAL,$(MIST_BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        Updater

PRODUCT_COPY_FILES += \
    vendor/mist/prebuilt/common/etc/init/init.mist-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.mist-updater.rc
endif

# Sign builds if building an official build
ifeq ($(filter-out OFFICIAL,$(MIST_BUILD_TYPE)),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(KEYS_LOCATION)
endif

ifeq ($(WITH_GAPPS),true)
MIST_EDITION := GAPPS
else
MIST_EDITION := VANILLA
endif

# Set all versions
BUILD_DATE := $(shell date -u +%Y%m%d)
BUILD_TIME := $(shell date -u +%H%M)
MIST_BUILD_VERSION := $(MIST_NUM_VER)-$(MIST_CODENAME)
MIST_VERSION := $(MIST_BUILD_VERSION)-$(MIST_BUILD)-$(MIST_BUILD_TYPE)-$(MIST_EDITION)-$(BUILD_TIME)-$(BUILD_DATE)
ROM_FINGERPRINT := mist/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(BUILD_TIME)
MIST_DISPLAY_VERSION := $(MIST_VERSION)
RELEASE_TYPE := $(MIST_BUILD_TYPE)

# MistOS System Version
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.mist.base.codename=$(MIST_CODENAME) \
    ro.mist.base.version=$(MIST_NUM_VER) \
    ro.mist.build.version=$(MIST_BUILD_VERSION) \
    ro.mist.build.date=$(BUILD_DATE) \
    ro.mist.buildtype=$(MIST_BUILD_TYPE) \
    ro.mist.display.version=$(MIST_DISPLAY_VERSION) \
    ro.mist.fingerprint=$(ROM_FINGERPRINT) \
    ro.mist.version=$(MIST_VERSION) \
    ro.modversion=$(MIST_VERSION) \
    ro.mistos.maintainer=$(MIST_MAINTAINER) \
    ro.mist.edition=$(MIST_EDITION)
