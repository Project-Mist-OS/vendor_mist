# Copyright (C) 2017 Unlegacy-Android
# Copyright (C) 2017 The LineageOS Project
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
# MistOS fastboot update package

MIST_TARGET_UPDATEPACKAGE := $(PRODUCT_OUT)/mist-$(MIST_VERSION)-fastboot.zip

.PHONY: updatepackage
updatepackage: $(INTERNAL_UPDATE_PACKAGE_TARGET)
	$(hide) ln -f $(INTERNAL_UPDATE_PACKAGE_TARGET) $(MIST_TARGET_UPDATEPACKAGE)
#	$(hide) $(SHA256) $(MIST_TARGET_UPDATEPACKAGE) | sed "s|$(PRODUCT_OUT)/||" > $(MIST_TARGET_UPDATEPACKAGE).sha256sum
	@echo -e "Package: $(MIST_TARGET_UPDATEPACKAGE)" >&2
	@echo -e "Checksum: `cat $(MIST_TARGET_UPDATEPACKAGE).sha256sum | awk '{ print $$1 }'`"
