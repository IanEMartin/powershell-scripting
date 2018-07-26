﻿<#
.SYNOPSIS
    .
.DESCRIPTION
    Gets the Last Logon Info for the users of a computer.
.PARAMETER System
    Specifies a single
.PARAMETER File
    Specifies a file with a list of systems
.EXAMPLE
    C:\PS> Get-LastUpdatedDate.ps1 -system sys1
    Gets the information for sys1
.NOTES
    Author: Ian Martin
    Date:   2013-11-12    
#>
[CmdletBinding()]
param (
    [Parameter(ValueFromPipeline=$true)]
	[string[]]$system,
    [string]$file
	)

If ($file -ne '')
	{
#	$LogInfo = 'File provided: '+$file
	Write-Verbose $LogInfo
#	$system = (Get-Content $file) | Sort-Object
#	$ListofMachines = $system
	$ListofMachines = (Get-Content $file) | Sort-Object
	}
ElseIf ($system -ne $null)
	{
	$LogInfo = 'System(s) provided: '+$system
	Write-Verbose $LogInfo
	$ListofMachines = $system | Sort-Object
	}
ELse
    {
    Exit
    }

Foreach ($Computer in $ListofMachines) 
	{
        $Updates = Get-WmiObject -Class "win32_quickfixengineering" -ComputerName $Computer | Select-Object -Property @{Name="InstalledOn"; Expression={([DateTime]($_.InstalledOn))}} | Sort-Object InstalledOn | Select -Last 1
        If ($Updates -ne $null)
            {
            $SystemLastUpdated = New-Object PSObject -Property @{
                Computer=$Computer.ToUpper()
                UpdatedOn=(get-date $Updates.InstalledOn -uformat '%Y-%m-%d')
                }
            $SystemLastUpdated = $SystemLastUpdated | Select-Object Computer, UpdatedOn
            $SystemLastUpdated
        }
    }
