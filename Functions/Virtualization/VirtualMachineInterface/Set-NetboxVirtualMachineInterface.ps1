﻿
function Set-NetboxVirtualMachineInterface {
    [CmdletBinding(ConfirmImpact = 'Medium',
                   SupportsShouldProcess = $true)]
    [OutputType([pscustomobject])]
    param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [uint16[]]$Id,

        [string]$Name,

        [string]$MAC_Address,

        [uint16]$MTU,

        [string]$Description,

        [boolean]$Enabled,

        [uint16]$Virtual_Machine,

        [switch]$Force
    )

    begin {

    }

    process {
        foreach ($VMI_ID in $Id) {
            Write-Verbose "Obtaining VM Interface..."
            $CurrentVMI = Get-NetboxVirtualMachineInterface -Id $VMI_ID -ErrorAction Stop
            Write-Verbose "Finished obtaining VM Interface"

            $Segments = [System.Collections.ArrayList]::new(@('virtualization', 'interfaces', $CurrentVMI.Id))

            if ($Force -or $pscmdlet.ShouldProcess("Interface $($CurrentVMI.Id) on VM $($CurrentVMI.Virtual_Machine.Name)", "Set")) {
                $URIComponents = BuildURIComponents -URISegments $Segments -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Id', 'Force'

                $URI = BuildNewURI -Segments $URIComponents.Segments

                InvokeNetboxRequest -URI $URI -Body $URIComponents.Parameters -Method PATCH
            }
        }
    }

    end {

    }
}