#
# Cookbook Name:: hana_client
# Recipe:: default
#
# Copyright 2016, SAP SE
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

Chef::Log.info "Starting the hana-client installer."

# If requested, uninistall previous HANA client versions.
hana_client "#{node['hana_client']['root_install_folder']}" do
  action :uninstall
  only_if { node['hana_client']['uninstall_reinstall'] }
end

# Extract the SAR file
remote_source = node['sap']['hanaclient']
sar_name = remote_source.split('/')[-1]
#temp_path = "#{Chef::Config[:file_cache_path].gsub("/", "\\")}/#{sar_name.split('.')[0]}"# Replace / with \\ to overcome bug of slashes
temp_path = "c:"

hana_client_sap_media "#{temp_path}" do
  remote_path remote_source
  sapcar node['sap']['sapcar']
  not_if  { ::Dir.exist?("#{temp_path}\\SAP_HANA_CLIENT") || ::File.exist?("#{node['hana_client']['root_install_folder']}\\hdbclient\\install\\hdbuninst.exe") }
end

# Install the client from the extracted SAR
execute "install #{sar_name}" do
  command "#{temp_path}\\SAP_HANA_CLIENT\\hdbinst.exe --batch --path=\"#{node['hana_client']['root_install_folder']}\\hdbclient"
  timeout 86400
  action :run
  not_if { ::File.exist?("#{node['hana_client']['root_install_folder']}\\hdbclient\\install\\hdbuninst.exe") }
end

# Cleanup the installer source file.
directory "#{temp_path}\\SAP_HANA_CLIENT\\" do
  recursive true
  action :delete
end
