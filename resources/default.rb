#
# Cookbook Name:: hana-client
# Resource:: default (hana_client)
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

property :destination, String, name_attribute: true, desired_state: false
property :source, String, desired_state: false
property :extractor, String, default: node['sap']['sapcar'], desired_state: false

alias_method :installer, :destination

load_current_value do |resource_attributes|
  current_value_does_not_exist! unless ::File.exist?(hana_cli_uninstaller(resource_attributes.destination))
end

action :install do
  converge_if_changed do
    # Extract the SAR
    sap_media sap_media_dir do
      pkg_source new_resource.source
      remote_sapcar_executable new_resource.extractor
      action :extract
    end

    # Install the client
    execute "Install HANA Client: #{new_resource.destination}" do
      cwd hana_cli_install_root
      command "#{hana_cli_installer} --batch --path=\"#{new_resource.destination}/hdbclient\""
      timeout 86_400
      action :run
      notifies :delete, "sap_media[#{sap_media_dir}]", :immediately
    end
  end
end

action :uninstall do # uninstalls all clients from the destination directory
  subdirs(new_resource.destination).each do |sub_dir|
    pwd = ::File.join(sub_dir.to_s)
    execute "Uninstall #{pwd}" do
      command "\"#{hana_cli_uninstaller(pwd)}\" --batch --path=\"#{new_resource.destination}/#{sub_dir}\""
      only_if { ::File.exist?(hana_cli_uninstaller(pwd)) && !sub_dir['hdbclient'].nil? }
    end
  end if ::Dir.exist?(new_resource.destination)
end

# Methods to help out readability of the action block
action_class do
  include ::Helpers # Shared methods for resources
  
  # methods that are private to this resource
  def sap_media_dir
    ::File.join(cache, 'sap_media')
  end

  def hana_cli_install_root
    ::File.join(sap_media_dir, 'SAP_HANA_CLIENT')
  end

  def hana_cli_installer
    installer = ::File.join(hana_cli_install_root, 'hdbinst')
    add_ext(installer)
  end
end

# A few more methods that needed outside of te action block
def hana_cli_uninstaller(client_path)
  uninstaller = ::File.join(client_path, 'hdbclient', 'install', 'hdbuninst')
  add_ext(uninstaller)
end

def add_ext(file)
  node['os'] == 'windows' ? file + '.exe' : file
end

def subdirs(directory)
  require 'pathname'
  contents = Pathname(directory).children
  contents.select(&:directory?)
end
