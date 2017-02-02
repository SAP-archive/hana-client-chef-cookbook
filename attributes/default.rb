#
# Cookbook Name:: hana-client
#
# Copyright 2016, SAP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#########################
##   Basic Attributes  ##
#########################

# The URL to the SAPCAR executable to be used for extracting the SAP package
default['sap']['sapcar'] = nil

# The complete URL to the SAP SAR package for the hana client to be installed
default['sap']['hanaclient'] = nil

#########################
## Advanced Attributes ##
#########################

# This is where the hana client will live on your system.
default['hana-client']['root_install_folder'] = 'c:/sap'

# Signals the removal of any existing hana clients in the install folder.
default['hana-client']['uninstall_reinstall'] = false
