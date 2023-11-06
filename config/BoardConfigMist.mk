include vendor/mist/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include hardware/qcom-caf/common/BoardConfigQcom.mk
endif

# MIST AVB Key
ifneq ($(filter OFFICIAL CI,$(MIST_BUILD_TYPE)),)
ifeq ($(TARGET_USES_MIST_AVB_KEY),true)
include vendor/mist/config/BoardConfigAvb.mk
endif
endif

include vendor/mist/config/BoardConfigSoong.mk

# Namespace for fwk-detect
TARGET_FWK_DETECT_PATH ?= hardware/qcom-caf/common
PRODUCT_SOONG_NAMESPACES += \
    $(TARGET_FWK_DETECT_PATH)/fwk-detect
