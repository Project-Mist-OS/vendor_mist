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

# Mist packages
PRODUCT_PACKAGES += \
    MistWallpaperStub \
    Glimpse \
    OmniStyle

# Extra tools in Mist
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/mist/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# rsync
PRODUCT_PACKAGES += \
    rsync

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += \
    vendor/mist/overlay \
    vendor/mist/overlay/no-rro

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/mist/overlay/common \
    vendor/mist/overlay/no-rro

PRODUCT_PACKAGES += \
    CustomPixelLauncherOverlay \
    DocumentsUIOverlay \
    NetworkStackOverlay

# BatteryStatsViewer
PRODUCT_PACKAGES += \
    BatteryStatsViewer

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

# Hide nav Overlays
PRODUCT_PACKAGES += \
    NavigationBarNoHintOverlay

# repainter
PRODUCT_PACKAGES += \
    RepainterServicePriv

# TouchGestures
PRODUCT_PACKAGES += \
    TouchGestures

# OmniJaws
PRODUCT_PACKAGES += \
    OmniJaws

# Launcher3
TARGET_INCLUDE_PIXEL_LAUNCHER ?= true
ifeq ($(TARGET_INCLUDE_PIXEL_LAUNCHER),false)
PRODUCT_PACKAGES += \
    Launcher3QuickStep

PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep
endif

# PocketMode
TARGET_INCLUDES_POCKET_MODE ?= true
ifeq ($(TARGET_INCLUDES_POCKET_MODE),true)
PRODUCT_PACKAGES += \
    PocketMode

PRODUCT_COPY_FILES += \
    packages/apps/PocketMode/privapp-permissions-pocketmode.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-pocketmode.xml
endif
