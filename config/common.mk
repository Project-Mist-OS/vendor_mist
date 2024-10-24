# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= MistOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/mist/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/mist/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/mist/prebuilt/common/bin/50-mist.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-mist.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-mist.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/mist/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/mist/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/mist/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

# Mist-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/mist/prebuilt/common/etc/init/init.mist-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.mist-system_ext.rc

# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=60 \
    ro.surface_flinger.enable_frame_rate_override=false

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= $(TARGET_SUPPORTS_64_BIT_APPS)

ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# Vanilla and GMS
WITH_GAPPS ?= true
ifeq ($(WITH_GAPPS), true)
$(call inherit-product-if-exists, vendor/gms/products/gms.mk)
else
include vendor/mist/config/vanilla.mk
endif

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Google Photos Pixel Exclusive XML
PRODUCT_COPY_FILES += \
    vendor/mist/prebuilt/common/etc/sysconfig/pixel_2016_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2016_exclusive.xml

# Lineage Hardware
PRODUCT_COPY_FILES += \
    vendor/mist/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-lineagehw.xml \
    vendor/mist/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml

# Overlay
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
WITH_DEXPREOPT_DEBUG_INFO := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Audio
include vendor/mist/audio/audio.mk

# Bootanimation
include vendor/mist/config/bootanimation.mk

# Relax Broken Library Check
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

# Call Recording
TARGET_CALL_RECORDING_SUPPORTED ?= true
ifneq ($(TARGET_CALL_RECORDING_SUPPORTED),false)
PRODUCT_COPY_FILES += \
    vendor/mist/config/permissions/com.google.android.apps.dialer.call_recording_audio.features.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.google.android.apps.dialer.call_recording_audio.features.xml
endif

# Certification
$(call inherit-product-if-exists, vendor/certification/config.mk)

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images \
    product_charger_res_images_vendor

PRODUCT_COPY_FILES += \
    vendor/mist/overlay/rro_packages/partition_order.xml:$(TARGET_COPY_OUT_PRODUCT)/overlay/partition_order.xml

# Mainline spoofing
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.pihooks_mainline_BRAND?=google \
    persist.sys.pihooks_mainline_DEVICE?=caiman \
    persist.sys.pihooks_mainline_MANUFACTURER?=Google \
    persist.sys.pihooks_mainline_PRODUCT?=caiman \
    ro.product.model_for_attestation?=Pixel 9 Pro \
    ro.product.brand_for_attestation?=google \
    ro.product.name_for_attestation?=caiman \
    ro.product.device_for_attestation?=caiman \
    ro.product.manufacturer_for_attestation?=Google

PRODUCT_BUILD_PROP_OVERRIDES += \
    PIHOOKS_BUILD_FINGERPRINT="google/caiman/caiman:14/AD1A.240530.047.U1/12150698:user/release-keys" \
    PIHOOKS_MODEL_SPOOF="Pixel 9 Pro"

#Themes OVerlay
include packages/overlays/Themes/themes.mk

# Include Mist Versioning
include vendor/mist/config/version.mk

# Include Mist Packages
include vendor/mist/config/packages.mk

# Include Mist_props
$(call inherit-product, vendor/mist/config/mist_props.mk)

#pixel fw
$(call inherit-product-if-exists, vendor/pixel-framework/config.mk)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
