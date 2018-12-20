#
# Cookbook Name:: hana-client
# Test:: default
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

require_relative '../helper.rb'

control 'SAPCAR' do
  impact 0.3
  desc '
    This test assures checks for an installed SAPCAR extractor.
  '

  describe file(::File.join(sapcar_path, platform_exec('SAPCAR'))) do
    it { should be_file }
  end
end

control 'SAP HANA client' do
  impact 1.0
  desc '
    These tests verify that the client is installed.
  '
  
  describe file(hana_client_path) do
    it { should be_directory }
  end
  
  describe file(hana_client_uninstaller) do
    it { should be_file }
  end
end

control 'Cleaned-Up' do
  impact 0.1
  desc '
    These tests make sure that the temporary installation files were removed.
  '
  describe file(::File.join(cache, 'sap_temp')) do
    it { should_not exist }
  end

  describe file(::File.join(cache, sar_file)) do
    it { should_not exist }
  end
end
