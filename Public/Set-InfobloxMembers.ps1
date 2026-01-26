function Set-InfobloxMembers {
    <#
    .SYNOPSIS
    Sets or modifies members for an Infoblox object.

    .DESCRIPTION
    Updates the members list for an object by reference ID, or resolves a network by CIDR.
    Supports replacing the full list or adding/removing members.

    .PARAMETER ReferenceID
    The Infoblox object reference ID (e.g. network/..., range/..., etc.).

    .PARAMETER Network
    The IPv4 network in CIDR notation (e.g. 10.46.5.128/25).

    .PARAMETER NetworkView
    The network view. Defaults to 'default'.

    .PARAMETER Members
    Full list of members to set on the object.

    .PARAMETER AddMembers
    Members to add to the existing list.

    .PARAMETER RemoveMembers
    Members to remove from the existing list.

    .PARAMETER MemberStruct
    The Infoblox member struct name. Defaults to 'msdhcpserver'.

    .PARAMETER MemberProperty
    The member property name holding the address/name. Defaults to 'ipv4addr'.

    .PARAMETER ReturnOutput
    If provided, returns the API response.

    .EXAMPLE
    Set-InfobloxMembers -Network '10.46.5.128/25' -Members @(
        'dhcp01.example.com',
        'dhcp02.example.com'
    )

    .EXAMPLE
    Set-InfobloxMembers -Network '10.46.5.128/25' -AddMembers 'dhcp02.example.com'

    .EXAMPLE
    Set-InfobloxMembers -ReferenceID 'network/...' -MemberStruct 'msdhcpserver' -MemberProperty 'ipv4addr' -RemoveMembers 'dhcp01.example.com'
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ReferenceID')][string] $ReferenceID,
        [Parameter(Mandatory, ParameterSetName = 'Network')][string] $Network,
        [Parameter(ParameterSetName = 'Network')][string] $NetworkView = 'default',
        [string[]] $Members,
        [string[]] $AddMembers,
        [string[]] $RemoveMembers,
        [string] $MemberStruct = 'msdhcpserver',
        [string] $MemberProperty = 'ipv4addr',
        [switch] $ReturnOutput
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Set-InfobloxMembers - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if (-not $Members -and -not $AddMembers -and -not $RemoveMembers) {
        Write-Warning -Message 'Set-InfobloxMembers - You must provide Members, AddMembers, or RemoveMembers'
        return
    }
    if ($Members -and ($AddMembers -or $RemoveMembers)) {
        Write-Warning -Message 'Set-InfobloxMembers - Use Members to replace or AddMembers/RemoveMembers to modify, not both'
        return
    }

    $Object = $null
    if ($PSCmdlet.ParameterSetName -eq 'Network') {
        $QueryParameter = [ordered]@{
            network        = $Network
            network_view   = $NetworkView
            _return_fields = "members,network,network_view"
        }
        $Object = Invoke-InfobloxQuery -RelativeUri 'network' -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
        if (-not $Object) {
            Write-Warning -Message "Set-InfobloxMembers - Network $Network not found"
            return
        }
        if ($Object -is [array]) {
            if ($Object.Count -gt 1) {
                Write-Warning -Message "Set-InfobloxMembers - Multiple networks found for $Network in view $NetworkView, using the first result."
            }
            $Object = $Object | Select-Object -First 1
        }
    } else {
        $QueryParameter = [ordered]@{
            _return_fields = 'members'
        }
        $Object = Invoke-InfobloxQuery -RelativeUri $ReferenceID -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
        if (-not $Object) {
            Write-Warning -Message "Set-InfobloxMembers - ReferenceID $ReferenceID not found"
            return
        }
    }

    $CurrentMembers = @()
    if ($Object.members) {
        foreach ($Member in $Object.members) {
            if ($Member.$MemberProperty) {
                $CurrentMembers += $Member.$MemberProperty
            }
        }
    }

    if ($Members) {
        $FinalMembers = $Members
    } else {
        $FinalMembers = $CurrentMembers
        if ($AddMembers) {
            foreach ($Member in $AddMembers) {
                if ($FinalMembers -notcontains $Member) {
                    $FinalMembers += $Member
                }
            }
        }
        if ($RemoveMembers) {
            $FinalMembers = $FinalMembers | Where-Object { $RemoveMembers -notcontains $_ }
        }
    }

    $FinalMembers = $FinalMembers | Where-Object { $_ } | Sort-Object -Unique

    $Body = [ordered] @{
        "members" = @(
            foreach ($Member in $FinalMembers) {
                [ordered] @{
                    "_struct"  = $MemberStruct
                    $MemberProperty = $Member
                }
            }
        )
    }

    Remove-EmptyValue -Hashtable $Body

    $invokeInfobloxQuerySplat = @{
        RelativeUri = if ($PSCmdlet.ParameterSetName -eq 'Network') { $Object._ref } else { $ReferenceID }
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Set-InfobloxMembers - Modified $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}
