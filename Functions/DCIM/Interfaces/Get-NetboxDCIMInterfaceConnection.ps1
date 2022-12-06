﻿
function Get-NetboxDCIMInterfaceConnection {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param
    (
        [uint16]$Limit,

        [uint16]$Offset,

        [uint16]$Id,

        [object]$Connection_Status,

        [uint16]$Site,

        [uint16]$Device,

        [switch]$Raw
    )

    if ($null -ne $Connection_Status) {
        $PSBoundParameters.Connection_Status = ValidateDCIMChoice -ProvidedValue $Connection_Status -InterfaceConnectionStatus
    }

    $Segments = [System.Collections.ArrayList]::new(@('dcim', 'interface-connections'))

    $URIComponents = BuildURIComponents -URISegments $Segments.Clone() -ParametersDictionary $PSBoundParameters -SkipParameterByName 'Raw'

    $URI = BuildNewURI -Segments $URIComponents.Segments -Parameters $URIComponents.Parameters

    InvokeNetboxRequest -URI $URI -Raw:$Raw
}