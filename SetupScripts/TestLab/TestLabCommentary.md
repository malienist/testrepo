# TestLab Design and Build

## Thanks and Acknowledgements
1. ** bottkars ** - the VMXToolkit is fundamental to automating much of the VMWareWorkstation component of the build. You can find it here: https://github.com/bottkars/vmxtoolkit

## Modules
New-TestLab - used after initial download to setup lab
 
## Build Process
### Ansible Server
The ansible server is the configuration controller for the test lab. By separating it out from the rest of testlab, the user is able to have more security on configuration.
#### Module: New-AnsibleServer


### SIEM
Through experimentation, the first thing which should be established is the SIEM.
That way all the logical accountability etc can be rolled out.

SIEM Server - Ubuntu 18.04 Server

### Domain Controller
This is the first object to be deployed. It requires a DSC file to be transferred as the DSC pull server has not yet been developed.
