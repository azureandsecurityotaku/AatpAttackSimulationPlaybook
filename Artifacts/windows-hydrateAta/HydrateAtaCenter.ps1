﻿# Do fix for Azure DevTest Lab DNS (point to ContosoDC)
# set DNS to ContosoDC IP
# get contosoDC IP
$contosoDcIp = (Resolve-DnsName "ContosoDC").IPAddress

# get current DNS
$currentDns = (Get-DnsClientServerAddress).ServerAddresses
# add contosodc to DNS list
$currentDns += $contosoDcIp

# make change to DNS with all DNS servers now
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses $currentDns

# turn on network discovery
Get-NetFirewallRule -DisplayGroup 'Network Discovery'|Set-NetFirewallRule -Profile 'Private, Domain' -Enabled true

# hide Server Manager at logon
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "0x1" -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Oobe -Name DoNotOpenInitialConfigurationTasksAtLogon -PropertyType DWORD -Value "0x1" -Force

# audit remote SAM
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Lsa -Name RestrictRemoteSamAuditOnlyMode -PropertyType DWORD -Value "0x1" -Force