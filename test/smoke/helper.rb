#
# Cookbook Name:: hana-client
# Kitchen:: docker linux
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

def kitchen_user
  'chef'
end

def cache
  return "c:\\Users\\#{kitchen_user}\\AppData\\Local\\Tmp\\kitchen\\cache" if os.windows?
  '/tmp/kitchen/cache'
end

def sapcar_path
  return 'c:\Windows\System32' if os.windows?
  '/usr/sbin'
end

def hana_client_path
  return 'c:\sap' if os.windows?
  '/opt/sap'
end

def hana_client_uninstaller
  ::File.join(hana_client_path, 'hdbclient', 'install', platform_exec('hdbuninst'))
end

def sar_file
  return 'SAP_HANA_CLIENT100_101_Windows_Server_on_x86_64.SAR' if os.windows?
  'SAP_HANA_CLIENT100_101_Linux_on_x86_64.SAR'
end

def platform_exec(file)
  return file + '.exe' if os.windows?
  file
end
