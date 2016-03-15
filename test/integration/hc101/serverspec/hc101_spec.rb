#
# Cookbook Name:: hana-client
# Test:: default
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

require 'serverspec'

set :backend, :cmd

describe file('c:\\Windows\\SAPCAR.EXE') do
  it { should be_file }
end

describe file('c:\\SAP') do
  it { should be_directory }
end

describe file('c:\\SAP\\hdbclient\\install\\hdbuninst.exe') do
  it { should be_file }
end
