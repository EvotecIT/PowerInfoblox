function Set-InfobloxNetworkMembers {
    <#
    .SYNOPSIS
    Sets or modifies members for an Infoblox object.

    .DESCRIPTION
    Updates the members list for an object by reference ID, or resolves a network by CIDR.
    Supports replacing the full list or adding/removing members.

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
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members @(
        'xe-s-dhcpis02p.xe.abb.com', 'se-s-dhcpap02p.se.abb.com'
    )

    .EXAMPLE
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers 'se-s-dhcpap02p.se.abb.com'

    .EXAMPLE
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -RemoveMembers 'xe-s-dhcpis02p.xe.abb.com'

    .EXAMPLE
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -MemberStruct 'dhcpmember' -MemberProperty 'name' -Members @(
        'dhcp01.example.com', 'dhcp02.example.com'
    )

    .EXAMPLE
    $customMembersSplat = @{
        Network        = '10.46.5.128/25'
        MemberStruct   = 'dhcpmember'
        MemberProperty = 'name'
        AddMembers     = 'dhcp03.example.com'
    }
    Set-InfobloxNetworkMembers @customMembersSplat

    .EXAMPLE
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members @()
    #>
    [Alias('Set-InfobloxMembers')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string] $Network,
        [string] $NetworkView = 'default',
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
        Write-Warning -Message 'Set-InfobloxNetworkMembers - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $hasMembers = $PSBoundParameters.ContainsKey('Members')
    $hasAddMembers = $PSBoundParameters.ContainsKey('AddMembers')
    $hasRemoveMembers = $PSBoundParameters.ContainsKey('RemoveMembers')

    if (-not $hasMembers -and -not $hasAddMembers -and -not $hasRemoveMembers) {
        Write-Warning -Message 'Set-InfobloxNetworkMembers - You must provide Members, AddMembers, or RemoveMembers'
        return
    }
    if ($hasMembers -and ($hasAddMembers -or $hasRemoveMembers)) {
        Write-Warning -Message 'Set-InfobloxNetworkMembers - Use Members to replace or AddMembers/RemoveMembers to modify, not both'
        return
    }

    $QueryParameter = [ordered]@{
        network        = $Network
        network_view   = $NetworkView
        _return_fields = "members,network,network_view"
    }
    $Object = Invoke-InfobloxQuery -RelativeUri 'network' -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
    if (-not $Object) {
        Write-Warning -Message "Set-InfobloxNetworkMembers - Network $Network not found"
        return
    }
    if ($Object -is [array]) {
        if ($Object.Count -gt 1) {
            Write-Warning -Message "Set-InfobloxNetworkMembers - Multiple networks found for $Network in view $NetworkView, using the first result."
        }
        $Object = $Object | Select-Object -First 1
    }

    $CurrentMembers = @()
    if ($Object.members) {
        foreach ($Member in $Object.members) {
            if ($Member.$MemberProperty) {
                $CurrentMembers += $Member.$MemberProperty
            }
        }
    }

    if ($hasMembers) {
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

    if ($FinalMembers.Count -gt 0) {
        Remove-EmptyValue -Hashtable $Body
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = $Object._ref
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Set-InfobloxNetworkMembers - Modified $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}
