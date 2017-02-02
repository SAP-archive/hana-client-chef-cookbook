#
# Cookbook Name:: hana-client
# Recipe:: default
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

# Some vars for readability
destination = node['hana-client']['root_install_folder']
extract_to_dir = Chef::Config[:file_cache_path] + '/sap_temp'
local_installer = extract_to_dir + '/SAP_HANA_CLIENT/hdbinst.exe'

# Get current state
extracted_client = extract_to_dir + '/SAP_HANA_CLIENT'
uninstaller = "#{destination}/hdbclient/install/hdbuninst.exe"

# If requested, uninistall previous HANA client versions.
hana_client 'Uninstall clients from ' + node['hana-client']['root_install_folder'] do
  name node['hana-client']['root_install_folder']
  action :uninstall
  only_if { node['hana-client']['uninstall_reinstall'] }
end

# Extract the SAR file
hana_client_sap_media extract_to_dir do
  remote_path node['sap']['hanaclient']
  sapcar node['sap']['sapcar']
  action :extract
  not_if { ::Dir.exist?(extracted_client) || ::File.exist?(uninstaller) }
end

# Install the client from the extracted SAR
hana_client 'Install client to ' + destination do
  name destination
  installer local_installer
  action :install
end

# Cleanup the installer source file.
directory extract_to_dir do
  recursive true
  action :delete
end
