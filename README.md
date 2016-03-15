# hana-client Cookbook
This cookbook installs the specified version of the SAP HANA Client on a windows
machine.  Just plug in the location of your `SAPCAR.exe` extractor, and the SAR
package.

This *is* a BYOP cookbook (**B**ring **Y**our **O**wn **P**ackage).  You
need to provide a download location for SAPCAR and the SAR package.   

## Supports

This cookbooks supports the following windows versions, and has been tested on
SAP's internal cloud and AWS as noted below.

|            OS          | Internally Tested | AWS EC2 Tested |
| ---------------------- | ----------------- | -------------- |
| Windows Server 2008    |         ⃠        |        ✓       |
| Windows Server 2008 R2 |         ✓        |        ✓       |
| Windows Server 2012    |         ⃠        |        ✓       |
| Windows Server 2012 R2 |         ✓        |        ✓       |
| Windows Server 2016 TP |         ✓        |        ⃠       |
| Windows 10             |         ✓        |        ⃠       |


## Attributes <a name="attributes"></a>
### Basic & Required
You need to provide these values to the cookbook so that it can install the
client on your system.  You may have specified these values as a part of
another cookbook.

|            Key          |   Type  |                                  Description                                  |  Default  |
|-------------------------|---------|-------------------------------------------------------------------------------|-----------|
| `['sap']['sapcar']`     | String  | The URL to the SAPCAR executable to be used for extracting the SAP package    | N/A       |
| `['sap']['hanaclient']` | String  | The complete URL to the SAP SAR package for the HANA client to be installed   | N/A       |

### Advanced & Optional
These attributes are used to fine tune the installation.

|                    Key                   |   Type  |                                  Description                                  |  Default  |
|------------------------------------------|---------|-------------------------------------------------------------------------------|-----------|
| `['hana-client']['root_install_folder']` | String  | This is where the HANA client will live on your system.                       | `c:\sap` |
| `['hana-client']['uninstall_resintall']` | Boolean | Signals the removal of any existing HANA clients in the `root_install_folder` | `false`   |

## Resource/Provider
### hana-client
#### Actions
 - `:install`
 - `:uninstall`

Use the actions to install or remove an installation of the client to or from
the specified location.  `uninstall` removes any HANA client(s) found in the
root path.
##### Example
```ruby
hana_client "C:\\Root\\Path\\To\\Install\\hana-clientent\\" do
  installer "C:\\Path\\To\\Extracted\\Installer\\hdbinst.exe"
  action :install
end
```
```ruby
hana_client "C:\\Root\\Path\\To\\Finhana-clientent\\" do
  action :uninstall
end
```
### hana_client_sap_media
Use `hana_client_sap_media` to extract an SAP SAR file to a specific location.
##### Example
```ruby
hana_client_sap_media "Source.SAR" do
  remote_path "Destination for extracted files"
  sapcar "URL://of.SAPCAR/for/extraction"
end
```

## Usage
### hana-client::default

So you want to install the HANA client?  In addition to the resources
provided above, you can use this cookbook's *default* recipe to install the SAP
HANA Client.  Here's how:
1. Depend on me (in your `metadata.rb`).
```ruby
depends 'hana-client'
```

- Tell me about your files (where to find them) and options (using
  [attributes](#attributes)).
 - **[REQUIRED]**: Location of SAPCAR.
 - **[REQUIRED]**: Location of the SAR package you want.
 - [OPTIONAL]: Change the default installation directory.
 - [OPTIONAL]: Set the reinstall flag to remove any previous client.

- Include `hana-client` in your node's `run_list`:
```json
{
  "name":"my_node",
  "run_list": [
    "recipe[hana-client]"
  ]
}
```

## Contributing
Contributions are welcomed!

1. Fork the repo
2. Create a feature branch (like `add_component_x`)
3. Write your change
4. Test your change
5. Submit a Pull Request using Github

## License and Authors
### Authors
- Emmanuel Iturbide (e.iturbide@sap.com)
- Dan-Joe Lopez (Dan-Joe.Lopez@sap.com)

### License

Copyright 2016, SAP

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
