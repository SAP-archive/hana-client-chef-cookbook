#
# Cookbook Name:: hana_client
# Providers:: sap_media
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

action :extract do
  #######################
  ## Collect Variables ##
  #######################

  # Where to put SAPCAR
  sapcar_dir = node['platform_family'] == 'windows' ? ENV['WINDIR'] : '/usr/local/bin/'
  # The file name of the sapcar executable
  sapcar_ex = new_resource.sapcar.split('/')[-1]

  # The full URL to the sar package
  sar_url = new_resource.remote_path
  # The file name of the sar package, for friendly logging
  sar_file = sar_url.split('/')[-1]
  # Where to put the extracted contents
  sar_extract_dir = new_resource.extractDir
  # The path to the local copy of the SAR
  local_sar = "#{Chef::Config[:file_cache_path]}/#{sar_file}"

  ########################
  ##  Download SAPCAR   ##
  ########################

  remote_file "#{sapcar_dir}/#{sapcar_ex}" do
    source new_resource.sapcar
    mode 0755
    action :create_if_missing
  end

  ######################
  ## Download the SAR ##
  ######################
  remote_file local_sar do
    source sar_url
    mode 0755
    action :create_if_missing
  end

  ##########################
  ## Extract the package  ##
  ##########################

  # Creates the destination directory
  directory sar_extract_dir do
    recursive true
  end

  # Use SAPCAR to extract the downloaded package to its destination
  execute "Extract media #{sar_file} to #{sar_extract_dir}" do
    command "#{sapcar_ex} -xf #{local_sar} -R #{sar_extract_dir}"
  end

  #####################
  ## Cleanup the SAR ##
  #####################

  file local_sar do
    action :delete
    backup false
  end
end # end action
