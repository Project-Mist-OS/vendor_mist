# Copyright (C) 2022-23 The MistOS Project
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

PRODUCT_BRAND ?= MistOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920
PRODUCT_PACKAGES += \
    bootanimation.zip

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Gapps
ifeq ($(BUILD_WITH_GAPPS),true)
$(call inherit-product-if-exists, vendor/gms/products/gms.mk)
endif

# Include AOSP audio files
include vendor/mist/config/aosp_audio.mk

# Incude Mist Branding
include vendor/mist/config/branding.mk

# Include Mist Packages
include vendor/mist/config/packages.mk
include vendor/prebuilts/prebuilts.mk

# Inherit SystemUI Clocks if they exist
$(call inherit-product-if-exists, vendor/SystemUIClocks/product.mk)

# ThemeOverlays
include packages/overlays/Themes/themes.mk

# Include Mist_props
$(call inherit-product, vendor/mist/config/mist_props.mk)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
