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
MIST_CODENAME := EOL
MIST_NUM_VER := 2.9.1

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

# OFFICIAL DEVICES CHECK
OFFICIAL_MAINTAINERS := $(shell cat mist-maintainers/mist.maintainers)
OFFICIAL_DEVICES := $(shell cat mist-maintainers/mist.devices)

ifeq ($(findstring $(MIST_BUILD), $(OFFICIAL_DEVICES)),)
  # Device not listed as official
  MIST_BUILD_TYPE := UNOFFICIAL
else
  # Check if builder is an official maintainer
  ifeq ($(findstring $(MIST_MAINTAINER), $(OFFICIAL_MAINTAINERS)),)
    # Builder not an official maintainer, warn and set unofficial
    $(warning **********************************************************************)
    $(warning *   There is already an official maintainer for $(MIST_BUILD)    *)
    $(warning *              Setting build type to UNOFFICIAL                      *)
    $(warning **********************************************************************)
    MIST_BUILD_TYPE := UNOFFICIAL
  else
    # Official maintainer building official device
    MIST_BUILD_TYPE := OFFICIAL
  endif
endif

# Enforce official build for official maintainers on official devices
ifeq ($(MIST_BUILD_TYPE), OFFICIAL)
  ifeq ($(findstring $(MIST_BUILD), $(OFFICIAL_DEVICES)),)
    # Shouldn't reach here, error for unexpected situation
    $(error **********************************************************)
    $(error *     A violation has been detected, aborting build      *)
    $(error **********************************************************)
  endif
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

# Signing
ifneq (eng,$(TARGET_BUILD_VARIANT))
ifneq (,$(wildcard vendor/mist/signing/keys/releasekey.pk8))
PRODUCT_DEFAULT_DEV_CERTIFICATE := vendor/mist/signing/keys/releasekey
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
endif
ifneq (,$(wildcard vendor/mist/signing/keys/otakey.x509.pem))
PRODUCT_OTA_PUBLIC_KEYS := vendor/mist/signing/keys/otakey.x509.pem
endif
endif
