#
# Cookbook Name:: hana-client
# Resource:: sap_media
#
# Copyright 2019, SAP
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

#
# The `sap_media` resource is used to extract an SAP SAR packaged application.
#
# It takes:
# - the remote location of the `sapcar` executable
# - the remote location of the SAR package
# - the destination where the extracted package should be placed
#

resource_name :sap_media

property :pgk_destination,          String,        name_property: true
property :pkg_source,               String,        desired_state: false
property :remote_sapcar_executable, String,        desired_state: false

# For compatibility with previous version, but updating names for clarity
alias_method :extractDir, :pgk_destination
alias_method :remote_path, :pkg_source
alias_method :sapcar, :remote_sapcar_executable

load_current_value do |desired_state|
  current_value_does_not_exist! unless ::Dir.exist?(desired_state.pgk_destination) && !::Dir.entries(desired_state.pgk_destination).empty?
end

action :extract do
  converge_if_changed do
    #######################
    ## Collect Variables ##
    #######################

    # Need to put the extractor somewhere it's on the path
    local_path = win? ? ENV['WINDIR'] : '/usr/sbin/'

    # The file name of the sapcar binary
    sapcar = ::File.basename(new_resource.remote_sapcar_executable)

    # The sar package information
    sar_source = new_resource.pkg_source
    sar_file = ::File.basename(sar_source)

    # Location extraction details
    sar_extraction_location = new_resource.pgk_destination
    temp_local_sar = ::File.join(cache, sar_file)

    # Download SAPCAR
    remote_file ::File.join(local_path, sapcar) do
      source new_resource.remote_sapcar_executable
      mode 00755 unless win?
      action :create_if_missing
    end

    # Download the SAR
    remote_file temp_local_sar do
      source sar_source
      mode 0755 unless win?
      action :create_if_missing
    end

    # Extract the package
    # Creates the destination directory
    directory sar_extraction_location do
      action :create
      recursive true
    end

    # Use SAPCAR to extract the downloaded package to its destination
    execute "Extract media #{sar_file} to #{sar_extraction_location}" do
      command "#{sapcar} -xf #{temp_local_sar} -R #{sar_extraction_location}"
      action :run
      notifies :delete, "remote_file[#{temp_local_sar}]", :immediately
    end
  end
end

action :delete do
  directory new_resource.pgk_destination do
    recursive true
    action :delete
  end
end

action_class do
  include ::Helpers
end
