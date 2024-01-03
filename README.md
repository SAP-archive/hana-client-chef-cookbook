![](https://img.shields.io/badge/STATUS-NOT%20CURRENTLY%20MAINTAINED-red.svg?longCache=true&style=flat)

# Important Notice
This public repository is read-only and no longer maintained.

# hana-client Cookbook

This cookbook installs the specified version of the SAP HANA Client on a windows
machine.  Just plug in the location of your `SAPCAR.exe` extractor, and the SAR
package.

This *is* a BYOP cookbook (**B**ring **Y**our **O**wn **P**ackage).  You
need to provide a download location for SAPCAR and the SAR package.   

## Supports

This cookbooks supports the following windows versions, having been tested on
the following GCP Public Images.

 * Windows Server 2012 R2
 * Windows Server 2012 R2 Core
 * Windows Server 2016
 * Windows Server 2016 Core
 * Windows Server 2019
 * Windows Server 2019 Core
 * Windows Server 2019 for Containers
 * Windows Server 2019 Core for Containers

## Attributes

### Basic & Required

When using the cookbook's default recipe, you need to provide these
values to the cookbook so that it can install the client on your
system.  You may have specified these values as a part of another cookbook.

|              Key             |   Type  |                                  Description                                  |  Default  |
|------------------------------|---------|-------------------------------------------------------------------------------|-----------|
| `['sap']['sapcar']`          | String  | The URL to the SAPCAR executable to be used for extracting the SAP package    | N/A       |
| `['hana-client']['package']` | String  | The complete URL to the SAP SAR package for the HANA client to be installed   | N/A       |

### Advanced & Optional

These attributes are used to fine tune the installation.

|                    Key                   |   Type  |                                  Description                                  |  Default  |
|------------------------------------------|---------|-------------------------------------------------------------------------------|-----------|
| `['hana-client']['destination']`         | String  | This is where the HANA client will live on your system.                       | `c:\sap`  |
| `['hana-client']['uninstall_resintall']` | Boolean | Signals the removal of any existing HANA clients in the `destination`         | `false`   |

## Custom Resource
If you would like greater control over the installation, you can use the following custom
resources in your cookbooks directly
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
  soruce "URI:://to.download/the/package.sar"
  action :install
end
```

```ruby
hana_client "C:\\Root\\Path\\To\\Find\\hana-clientent\\" do
  action :uninstall
end
```

## License and Authors

### Authors

- Emmanuel Iturbide (e.iturbide@sap.com)
- Dan-Joe Lopez (Dan-Joe.Lopez@sap.com)

### License

Copyright 2016-2021 SAP SE or an SAP affiliate company and hana-client-chef-cookbook contributors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Detailed information including third-party components and their licensing/copyright information is available [via the REUSE tool](https://api.reuse.software/info/github.com/SAP/hana-client-chef-cookbook).
