# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
# Copyright (C) 2018,2020 The PixelExperience Project
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

MIST_TARGET_PACKAGE := $(PRODUCT_OUT)/$(MIST_VERSION).zip

SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum
MD5 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/md5sum

CL_PRP="\033[35m"
CL_RED="\033[31m"
CL_GRN="\033[32m"

.PHONY: bacon
bacon: $(DEFAULT_GOAL) $(INTERNAL_OTA_PACKAGE_TARGET)
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(MIST_TARGET_PACKAGE)
	$(hide) $(MD5) $(MIST_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(MIST_TARGET_PACKAGE).sha256sum
	$(hide) $(MD5) $(MIST_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(MIST_TARGET_PACKAGE).md5sum
	$(hide) ./vendor/mist/build/tasks/createjson.sh $(TARGET_DEVICE) $(PRODUCT_OUT) $(MIST_VERSION).zip $(MISTVERSION)
	@echo -e ${CL_CYN}""${CL_CYN}
	@echo -e ${CL_CYN}"     ___  ____     _     _____ _____    "${CL_CYN}
	@echo -e ${CL_CYN}"    |  \/  (_)   | |   |  _  /  ___|    "${CL_CYN}
	@echo -e ${CL_CYN}"    | .  . |_ ___| |_  | | | \ `--.     "${CL_CYN}
	@echo -e ${CL_CYN}"    | |\/| | / __| __| | | | |`--. \    "${CL_CYN}
	@echo -e ${CL_CYN}"    | |  | | \__ \ |_  \ \_/ /\__/ /    "${CL_CYN}
	@echo -e ${CL_CYN}"    \_|  |_/_|___/\__|  \___/\____/     "${CL_CYN}
	@echo -e ${CL_CYN}"                                        "${CL_CYN}
	@echo -e ${CL_CYN}"===========-Package Completed-==========="${CL_RST}
	@echo -e ${CL_BLD}${CL_GRN}"Zip: "${CL_RED} $(MIST_TARGET_PACKAGE)${CL_RST}
	@echo -e ${CL_BLD}${CL_GRN}"MD5: "${CL_RED}" `cat $(MIST_TARGET_PACKAGE).md5sum | cut -d ' ' -f 1` "${CL_RST}
	@echo -e ${CL_BLD}${CL_GRN}"SHA256: "${CL_RED}" `sha256sum $(MIST_TARGET_PACKAGE) | cut -d ' ' -f 1` "${CL_RST}
	@echo -e ${CL_BLD}${CL_GRN}"Size: "${CL_RED}" `ls -l $(MIST_TARGET_PACKAGE) | cut -d ' ' -f 5` "${CL_RST}
	@echo -e ${CL_CYN}"===========-----Thanks :)-----==========="${CL_RST}
	@echo -e ""
