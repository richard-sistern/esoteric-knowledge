# Compute

## Virtual Machine

### Automanage

The [Azure Automange](https://learn.microsoft.com/en-AU/azure/automanage/overview-about) automatically onboards VMs to services condidered [best practise](https://learn.microsoft.com/en-AU/azure/automanage/automanage-windows-server) for given the environment

### Azure Instance Metadata Service (IMDS)

The [Instance Metadata Service](https://learn.microsoft.com/en-us/azure/virtual-machines/instance-metadata-service?tabs=windows) provides an endpoint availible inside guests which can be used to communicate with ARM to get information/metadata.  For example:

- VM creation timestamp
- Resource tags

See PowerShell examples by John Saville

- [Set and retrieve user data](https://github.com/johnthebrit/AzureMasterClass/blob/master/Part07VMandVMSS/UserData.ps1)
- [Check creation date](https://github.com/johnthebrit/AzureMasterClass/blob/master/Part07VMandVMSS/CheckCreationDate.ps1)
- [General information and termination events](https://github.com/johnthebrit/AzureMasterClass/blob/master/Part07VMandVMSS/VMSSTerminate.ps1)
