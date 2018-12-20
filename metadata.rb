name             'hana-client'
maintainer       'SAP'
maintainer_email 'Dan-Joe.Lopez@sap.com'
license          'Apache-2.0'
description      'Installs/Configures Hana Client for Windows only'
source_url       'https://github.com/sap/hana-client-chef-cookbook' if respond_to?(:source_url)
issues_url       'https://github.com/sap/hana-client-chef-cookbook/issues' if respond_to?(:issues_url)
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.1'

chef_version     '>= 12' if respond_to?(:chef_version)

issues_url       'https://github.com/SAP/hana-client-chef-cookbook/issues' if respond_to?(:issues_url)
source_url       'https://github.com/SAP/hana-client-chef-cookbook' if respond_to?(:source_url)

%w( centos redhat suse opensuse windows ).each do |os|
  supports os
end
