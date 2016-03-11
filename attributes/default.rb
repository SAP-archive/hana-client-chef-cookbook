#
# Cookbook Name:: hana_client
#
# Copyright 2016, SAP
#
# All rights reserved - Do Not Redistribute
#

#########################
##   Basic Attributes  ##
#########################

# The URL to the SAPCAR executable to be used for extracting the SAP package
default['sap']['sapcar'] = nil

# The complete URL to the SAP SAR package for the hana client to be installed
default['sap']['hanaclient'] = nil


#########################
## Advanced Attributes ##
#########################

# This is where the hana client will live on your system.
default['hana_client']['root_install_folder'] = "c:\\sap"

# Signals the removal of any existing hana clients in the install folder.
default['hana_client']['uninstall_reinstall'] = false
