#
# Cookbook:: hana-client
# Recipe:: default
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

# If requested, uninistall previous HANA client versions.
hana_client node['hana-client']['destination'] do
  action :uninstall
end if node['hana-client']['clean']

# Install the hana client from a sar package
hana_client node['hana-client']['destination'] do
  source node['hana-client']['package']
  action :install
end
