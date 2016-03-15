#
# Cookbook Name:: hana-client
# Providers:: uninstall
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

use_inline_resources

action :uninstall do
  if ::Dir.exist?(new_resource.name)
    ::Dir.open(new_resource.name).each do |dir|
      batch "uninstall #{dir}" do
        code "\"#{new_resource.name}\\#{dir}\\install\\hdbuninst.exe\" --batch --path=\"#{new_resource.name}\\#{dir}\""
        only_if { ::File.exist?("#{new_resource.name}\\#{dir}\\install\\hdbuninst.exe") && !dir['hdbclient'].nil? }
      end # end batch
    end # end each
  end # end if
end # end action

action :install do
  execute "Install HANA Client: #{new_resource.name}" do
    command "#{new_resource.installer} --batch --path=\"#{new_resource.name}\\hdbclient"
    timeout 86_400
    action :run
    not_if { ::File.exist?("#{new_resource.name}\\hdbclient\\install\\hdbuninst.exe") }
  end
end
