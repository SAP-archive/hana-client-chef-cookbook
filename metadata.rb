name             'hana-client'
maintainer       'SAP'
maintainer_email 'Dan-Joe.Lopez@sap.com'
license          'Apache 2.0'
description      'Installs/Configures Hana Client for Windows only'
source_url       'https://github.com/sap/hana-client-chef-cookbook' if respond_to?(:source_url)
issues_url       'https://github.com/sap/hana-client-chef-cookbook/issues' if respond_to?(:issues_url)
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.1.0'

%w( centos redhat suse opensuse windows ).each do |os|
  supports os
end
