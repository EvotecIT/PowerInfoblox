function Get-InfobloxIPAddress {
    <#
    .SYNOPSIS
    Get Infoblox IP Address information for given network or IP address

    .DESCRIPTION
    Get Infoblox IP Address information for given network or IP address

    .PARAMETER Network
    Find IP address information for a specific network

    .PARAMETER IPv4Address
    Find IP address information for a specific IP address

    .PARAMETER Status
    Get IP addresses with a specific status, either Used or Unused

    .PARAMETER Name
    Get IP addresses with a specific name

    .PARAMETER Count
    Limit the number of results returned

    .EXAMPLE
    Get-InfobloxIPAddress -Network '10.2.2.0/24'

    .EXAMPLE
    Get-InfobloxIPAddress -Network '10.2.2.0/24' -Status Used -Verbose | Format-Table

    .EXAMPLE
    Get-InfobloxIPAddress -Network '10.2.2.0' -Verbose | Format-Table

    .NOTES
    General notes
    #>
    [cmdletbinding()]
    param(
        [parameter(ParameterSetName = 'Network')][string] $Network,
        [parameter(ParameterSetName = 'IPv4')][string] $IPv4Address,

        [parameter(ParameterSetName = 'Network')]
        [parameter(ParameterSetName = 'IPv4')]
        [parameter()][ValidateSet('Used', 'Unused')][string] $Status,

        [parameter(ParameterSetName = 'Network')]
        [parameter(ParameterSetName = 'IPv4')]
        [parameter()][string] $Name,

        [parameter(ParameterSetName = 'Network')]
        [parameter(ParameterSetName = 'IPv4')]
        [alias('Quantity')][parameter()][int] $Count
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxIPAddress - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($Network) {
        Write-Verbose -Message "Get-InfobloxIPAddress - Requesting Network [$Network] Status [$Status]"
    } else {
        Write-Verbose -Message "Get-InfobloxIPAddress - Requesting IPv4Address [$IPv4Address] Status [$Status]"
    }

    $invokeInfobloxQuerySplat = [ordered]@{
        RelativeUri    = 'ipv4address'
        Method         = 'GET'
        QueryParameter = [ordered]@{
            _max_results = 1000000
        }
    }
    if ($Network) {
        $invokeInfobloxQuerySplat.QueryParameter.network = $Network
    }
    if ($Status) {
        $invokeInfobloxQuerySplat.QueryParameter.status = $Status.ToUpper()
    }
    if ($Name) {
        $invokeInfobloxQuerySplat.QueryParameter.names = $Name
    }
    if ($IPv4Address) {
        $invokeInfobloxQuerySplat.QueryParameter.ip_address = $IPv4Address
    }
    if ($Count) {
        Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false | Select-Object -First $Count | Select-ObjectByProperty -LastProperty '_ref'
    } else {
        Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false | Select-ObjectByProperty -LastProperty '_ref'
    }
}