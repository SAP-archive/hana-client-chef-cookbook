# hana_client Cookbook
This cookbook installs the specified version of the SAP HANA Client on a windows
machine.  Just plug in the location of your `SAPCAR.exe` extractor, and the SAR
package.

## Supports

This cookbooks supports the following windows versions, and has been tested on
baremetal, AWS and Azure.
- Windows Server
  - 2008
  - 2008 R2
  - 2012
  - 2012 R2
  - 2016
- Windows Desktop (pro edition)
  - 7
  - 7 SP1
  - 8
  - 8.1
  - 10


## Attributes
### Basic & Required
You need to provide these values to the cookbook so that it can install the
client on your system.  You may have specified these values as a part of
another cookbook.

|            Key          |   Type  |                                  Description                                  |  Default  |
|-------------------------|---------|-------------------------------------------------------------------------------|-----------|
| `['sap']['sapcar']`     | String  | The URL to the SAPCAR executable to be used for extracting the SAP package    | N/A       |
| `['sap']['hanaclient']` | String  | The complete URL to the SAP SAR package for the hana client to be installed   | N/A       |

### Advanced & Optional
These attributes are used to fine tune the installation.

|                    Key                   |   Type  |                                  Description                                  |  Default  |
|------------------------------------------|---------|-------------------------------------------------------------------------------|-----------|
| `['hana_client']['root_install_folder']` | String  | This is where the hana client will live on your system.                       | `c:\\sap` |
| `['hana_client']['uninstall_resintall']` | Boolean | Signals the removal of any existing hana clients in the `root_install_folder` | `false`   |

## LWRPs
### sap_media
Use `sap_media` to extract an SAP SAR file to a specific location.
```ruby
hana_client_sap_media "Source.SAR" do
  remote_path "Destination for extracted files"
  sapcar "URL://of.SAPCAR/for/extraction"
end
```
### uninstall
Use uninstall to remove an installation of the client form the specified
location.
```ruby
hana_client_sap_media "Source.SAR" do
  remote_path "Destination for extracted files"
  sapcar "URL://of.SAPCAR/for/extraction"
end
```
### upgrade

## Usage
### hana_client::default

Just include `hana_client` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[hana_client]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Emmanuel Iturbide (e.iturbide@sap.com)
