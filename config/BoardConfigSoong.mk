PATH_OVERRIDE_SOONG := $(shell echo $(TOOLS_PATH_OVERRIDE))

# Add variables that we wish to make available to soong here.
EXPORT_TO_SOONG := \
    KERNEL_ARCH \
    KERNEL_BUILD_OUT_PREFIX \
    KERNEL_CROSS_COMPILE \
    KERNEL_MAKE_CMD \
    KERNEL_MAKE_FLAGS \
    KERNEL_PATH \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_SOURCE \
    TARGET_KERNEL_PLATFORM_TARGET \
    TARGET_MAX_PAGE_SIZE_SUPPORTED \
    TARGET_PREBUILT_KERNEL_HEADERS

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += lineageVarsPlugin

SOONG_CONFIG_lineageVarsPlugin :=

define addVar
  SOONG_CONFIG_lineageVarsPlugin += $(1)
  SOONG_CONFIG_lineageVarsPlugin_$(1) := $($1)
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

SOONG_CONFIG_NAMESPACES += lineageGlobalVars
SOONG_CONFIG_lineageGlobalVars += \
    spoof_first_api_level_32

# Soong bool variables
SOONG_CONFIG_lineageGlobalVars_spoof_first_api_level_32 := $(SPOOF_FIRST_API_LEVEL_32)

# Charger
lineage_charger_density := mdpi
ifneq (,$(TARGET_SCREEN_DENSITY))
lineage_charger_density := $(strip \
  $(or $(if $(filter $(shell echo $$(($(TARGET_SCREEN_DENSITY) >= 560))),1),xxxhdpi),\
       $(if $(filter $(shell echo $$(($(TARGET_SCREEN_DENSITY) >= 400))),1),xxhdpi),\
       $(if $(filter $(shell echo $$(($(TARGET_SCREEN_DENSITY) >= 280))),1),xhdpi),\
       $(if $(filter $(shell echo $$(($(TARGET_SCREEN_DENSITY) >= 200))),1),hdpi,mdpi)))
else ifneq (,$(filter mdpi hdpi xhdpi xxhdpi xxxhdpi,$(PRODUCT_AAPT_PREF_CONFIG)))
# If PRODUCT_AAPT_PREF_CONFIG includes a dpi bucket, then use that value.
lineage_charger_density := $(PRODUCT_AAPT_PREF_CONFIG)
endif
$(call soong_config_set,lineage_charger,density,$(lineage_charger_density))

# Libui
ifneq ($(TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS),)
    $(call soong_config_set,libui,additional_gralloc_10_usage_bits,$(TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS))
endif
