PRODUCT_VERSION_MAJOR = 15
PRODUCT_VERSION_MINOR = 0

# Increase Mist Version with each major release.
MIST_VERSION := 3.0-Beta

# Internal version
LINEAGE_VERSION := ProjectMistOS-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%Y%m%d)-$(LINEAGE_BUILD)-v$(MIST_VERSION)

# Display version
LINEAGE_DISPLAY_VERSION := v$(MIST_VERSION)-$(shell date +%Y%m%d)

# LineageOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.mist.build.version=$(LINEAGE_VERSION) \
    ro.mist.display.version=$(LINEAGE_DISPLAY_VERSION) \
    ro.mist.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR) \
    ro.modversion=$(MIST_VERSION)
