# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017,2020 The LineageOS Project
# Copyright (C) 2025 MistOS Project
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

# -----------------------------------------------------------------
# MistOS OTA update package

LINEAGE_TARGET_PACKAGE := $(PRODUCT_OUT)/$(LINEAGE_VERSION).zip
SHA256 := prebuilts/build-tools/path/$(HOST_PREBUILT_TAG)/sha256sum

$(LINEAGE_TARGET_PACKAGE): $(INTERNAL_OTA_PACKAGE_TARGET)
	@BUILD_START=$(shell date +%s); \
	mv -f $(INTERNAL_OTA_PACKAGE_TARGET) $(LINEAGE_TARGET_PACKAGE); \
	$(SHA256) $(LINEAGE_TARGET_PACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(LINEAGE_TARGET_PACKAGE).sha256sum; \
	echo "Creating json OTA..." >&2; \
	./vendor/lineage/build/tools/createjson.sh $(TARGET_DEVICE) $(PRODUCT_OUT) $(LINEAGE_VERSION).zip $(MIST_VERSION_BASE) $(MIST_CODENAME) $(MIST_PACKAGE_TYPE) $(MIST_RELEASE_TYPE); \
	cp -f $(PRODUCT_OUT)/$(TARGET_DEVICE).json vendor/official_devices/$(MIST_PACKAGE_TYPE)/$(TARGET_DEVICE).json; \
	rm -rf $(call intermediates-dir-for,PACKAGING,target_files); \
	BUILD_END=$$(date +%s); \
	BUILD_DURATION=$$((BUILD_END - BUILD_START)); \
	./vendor/lineage/build/tasks/ascii_output.sh "$(TARGET_DEVICE)" "$(LINEAGE_VERSION)" "$(MIST_VERSION_BASE)" "$(MIST_PACKAGE_TYPE)" "$(MIST_BUILD_TYPE)" "$(PRODUCT_OUT)/$(LINEAGE_VERSION).zip" "$(MISTOS_MAINTAINER)" "$${BUILD_DURATION}"

.PHONY: bacon
bacon: $(LINEAGE_TARGET_PACKAGE) $(DEFAULT_GOAL)
