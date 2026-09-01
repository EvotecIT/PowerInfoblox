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
        'dhcp01.example.com', 'dhcp02.example.com'
    )

    .EXAMPLE
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers 'dhcp02.example.com'

    .EXAMPLE
    Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -RemoveMembers 'dhcp01.example.com'

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

    $NeedsCurrentMembers = $hasAddMembers -or $hasRemoveMembers
    $QueryParameter = [ordered]@{
        network      = $Network
        network_view = $NetworkView
    }
    $Object = Invoke-InfobloxQuery -RelativeUri 'network' -Method 'GET' -QueryParameter $QueryParameter -WhatIf:$false
    if (-not $Object) {
        Write-Warning -Message "Set-InfobloxNetworkMembers - Network $Network not found"
        return
    }
    if ($Object -is [array]) {
        if ($Object.Count -gt 1) {
            Write-Error -Category InvalidData -Message "Set-InfobloxNetworkMembers - Multiple networks were returned for $Network in view $NetworkView. No changes were made."
            return
        }
        $Object = $Object | Select-Object -First 1
    }

    $CurrentMemberObject = $Object
    if ($NeedsCurrentMembers -and $null -eq $CurrentMemberObject.PSObject.Properties['members']) {
        try {
            $CurrentMemberObject = Invoke-InfobloxQuery -RelativeUri $Object._ref -Method 'GET' -QueryParameter @{ _return_fields = 'members' } -ErrorAction Stop -WhatIf:$false
        } catch {
            Write-Verbose -Message "Set-InfobloxNetworkMembers - Reading members for $($Object._ref) failed. $($_.Exception.Message)"
            $CurrentMemberObject = $null
        }
        if ($CurrentMemberObject -is [array]) {
            $CurrentMemberObject = $CurrentMemberObject | Select-Object -First 1
        }
    }
    if ($NeedsCurrentMembers -and (-not $CurrentMemberObject -or $null -eq $CurrentMemberObject.PSObject.Properties['members'])) {
        Write-Error -Category InvalidData -Message 'Set-InfobloxNetworkMembers - The connected Grid did not return readable network members. AddMembers and RemoveMembers cannot safely calculate an update. Use Members to replace the complete list or use a WAPI endpoint whose network schema supports reading members.'
        return
    }

    if ($hasMembers) {
        $FinalMemberObjects = @(
            foreach ($Member in ($Members | Where-Object { $_ } | Sort-Object -Unique)) {
                [ordered] @{
                    '_struct'      = $MemberStruct
                    $MemberProperty = $Member
                }
            }
        )
    } else {
        $FinalMemberObjects = @($CurrentMemberObject.members)
        if ($AddMembers) {
            $CurrentMemberValues = @(
                foreach ($MemberObject in $FinalMemberObjects) {
                    if ($MemberObject.$MemberProperty) {
                        $MemberObject.$MemberProperty
                    }
                }
            )
            foreach ($Member in ($AddMembers | Where-Object { $_ } | Sort-Object -Unique)) {
                if ($CurrentMemberValues -notcontains $Member) {
                    $FinalMemberObjects += [ordered] @{
                        '_struct'      = $MemberStruct
                        $MemberProperty = $Member
                    }
                    $CurrentMemberValues += $Member
                }
            }
        }
        if ($RemoveMembers) {
            $FinalMemberObjects = @(
                foreach ($MemberObject in $FinalMemberObjects) {
                    if ($RemoveMembers -notcontains $MemberObject.$MemberProperty) {
                        $MemberObject
                    }
                }
            )
        }
    }

    $Body = [ordered] @{
        'members' = @($FinalMemberObjects)
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
