PRODUCT_VERSION_MAJOR = 16
PRODUCT_VERSION_MINOR = 0

# Increase Mist Version with each major release.
MIST_VERSION_DISPLAY := 4.4-Zephyr
MIST_FLAVOR := Baklava
MIST_VERSION_BASE := 4.4
MIST_CODENAME := Zephyr
MIST_BUILD_TYPE ?= Unofficial

MIST_BUILD_DATE := $(shell date -u +%Y%m%d)

CURRENT_DEVICE := $(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
OFFICIAL_MAINTAINERS := $(shell cat mist-maintainers/mist.maintainers)
OFFICIAL_DEVICES := $(shell cat mist-maintainers/mist.devices)

ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
  # Device not listed as official
  MIST_BUILD_TYPE := UNOFFICIAL
else
  # Check if builder is an official maintainer
  ifeq ($(findstring $(MISTOS_MAINTAINER), $(OFFICIAL_MAINTAINERS)),)
    # Builder not an official maintainer, warn and set unofficial
    $(warning **********************************************************************)
    $(warning *   There is already an official maintainer for $(LINEAGE_BUILD)    *)
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
  ifeq ($(findstring $(LINEAGE_BUILD), $(OFFICIAL_DEVICES)),)
    # Shouldn't reach here, error for unexpected situation
    $(error **********************************************************)
    $(error *     A violation has been detected, aborting build      *)
    $(error **********************************************************)
  endif
endif


# Mist Packages
#ifeq ($(WITH_GMS),true)
#  ifeq ($(TARGET_USES_MINI_GAPPS), true)
#    MIST_PACKAGE_TYPE ?= MINI
#  else ifeq ($(TARGET_USES_PICO_GAPPS), true)
#    MIST_PACKAGE_TYPE ?= PICO
#  else
#    MIST_PACKAGE_TYPE ?= GAPPS
#  endif
#else
#  MIST_PACKAGE_TYPE ?= VANILLA
#endif

# Internal version
LINEAGE_VERSION := MistOS-$(MIST_VERSION_BASE)-$(MIST_CODENAME)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(MIST_PACKAGE_TYPE)-$(shell date +%Y%m%d)-$(LINEAGE_BUILD)-$(MIST_BUILD_TYPE)

# Display version
LINEAGE_DISPLAY_VERSION := MistOS-$(MIST_VERSION_BASE)-$(MIST_CODENAME)-$(MIST_PACKAGE_TYPE)-$(LINEAGE_BUILD)-$(MIST_BUILD_TYPE)-$(shell date +%Y%m%d)

# LineageOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.mist.version=$(LINEAGE_VERSION) \
    ro.mist.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.mist.build.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(MIST_VERSION) \
    ro.mist.packagetype=$(MIST_PACKAGE_TYPE) \
    ro.mist.version_display=$(MIST_VERSION_DISPLAY) \
    ro.mist.version.base=$(MIST_VERSION_BASE) \
    ro.mistos.maintainer=$(MISTOS_MAINTAINER) \
    ro.mistos.flavor=$(MIST_FLAVOR) \
    ro.mist.codename=$(MIST_CODENAME) \
    ro.mist.buildtype=$(MIST_BUILD_TYPE)
