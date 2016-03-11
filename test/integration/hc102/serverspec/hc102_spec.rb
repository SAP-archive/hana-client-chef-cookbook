require 'serverspec'

set :backend, :cmd

describe file('c:\\SAP') do
  it { should be_directory }
end

describe file('c:\\SAP\\hdbclient\\install\\hdbuninst.exe') do
  it  { should be_file }
end
