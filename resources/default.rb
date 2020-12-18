#
# Cookbook:: hana-client
# Resource:: default (hana_client)
#
# Copyright:: 2019, SAP
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

property :destination, String, name_property: true
property :source,      String
property :extractor,   String, default: node['sap']['sapcar']

alias_method :installer, :destination

load_current_value do |desired|
  destination '' unless ::Dir.exist?(desired.destination) && ::File.exist?("#{desired.destination}/install/hdbuninst.exe")
end

action :install do
  converge_if_changed :destination do
    temp_extract_dir = "#{Chef::Config[:file_cache_path]}\\sap_temp"
    installer_file = temp_extract_dir + '\SAP_HANA_CLIENT\hdbinst.exe'

    # Extract the remote installer
    hana_studio_remote_package temp_extract_dir do
      source new_resource.source
      creates installer_file
      extractor new_resource.extractor if new_resource.extractor
      action :extract
    end

    execute 'dir' do
      live_stream true
    end
    execute 'dir' do
      cwd temp_extract_dir + '\SAP_HANA_CLIENT'
      live_stream true
    end

    # Install the client
    execute "Install HANA Client: #{new_resource.destination}" do
      cwd temp_extract_dir + '\SAP_HANA_CLIENT'
      command "hdbinst.exe --batch --path=\"#{new_resource.destination}\""
      live_stream true
      timeout 86_400
      action :run
    end

    directory temp_extract_dir do
      recursive true
      action :delete
    end
  end
end

action :uninstall do # uninstalls client from the destination directory(ies)
  [new_resource.destination].flatten.each do |path| # force to an array and flatten in case it already was
    pwd = ::File.join(path.to_s)
    next unless ::File.exist?(hana_cli_uninstaller(pwd)) && !path['hdbclient'].nil?

    execute "Uninstall #{pwd}" do
      command "\"#{hana_cli_uninstaller(pwd)}\" --batch --path=\"#{new_resource.destination}\""
    end
  end if ::Dir.exist?(new_resource.destination)
end

# Methods to help out readability of the action block
action_class do
  def hana_cli_uninstaller(client_path)
    uninstaller = ::File.join(client_path, 'install', 'hdbuninst')
    uninstaller += '.exe' if platform_family?('windows')
    uninstaller
  end

  def subdirs(directory)
    require 'pathname'
    contents = Pathname(directory).children
    contents.select(&:directory?)
  end
end
