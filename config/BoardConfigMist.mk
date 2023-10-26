include vendor/mist/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/mist/config/BoardConfigQcom.mk
endif

include vendor/mist/config/BoardConfigSoong.mk
