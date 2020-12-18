name             'hana-client'
maintainer       'SAP'
maintainer_email 'Dan-Joe.Lopez@sap.com'
license          'Apache-2.0'
description      'Installs/Configures Hana Client for Windows only'
version          '3.0.1'

chef_version     '>= 15'

issues_url       'https://github.com/SAP/hana-client-chef-cookbook/issues'
source_url       'https://github.com/SAP/hana-client-chef-cookbook'

%w( centos redhat suse opensuse windows ).each do |os|
  supports os
end

depends 'hana-studio', '~>2.0'
