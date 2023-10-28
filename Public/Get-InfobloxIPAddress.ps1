function Get-InfobloxIPAddress {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Network
    Parameter description

    .EXAMPLE
    Get-InfobloxIPAddress -Network '10.2.2.0/24'

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
        [parameter()][int] $Count
    )
    if (-not $Script:InfobloxConfiguration) {
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

        }
    }
    if ($Network) {
        $invokeInfobloxQuerySplat.QueryParameter.network = $Network
    }
    if ($Status) {
        $invokeInfobloxQuerySplat.QueryParameter.status = $Status
    }
    if ($IPv4Address) {
        $invokeInfobloxQuerySplat.QueryParameter.ip_address = $IPv4Address
    }
    if ($Count) {
        Invoke-InfobloxQuery @invokeInfobloxQuerySplat | Select-Object -First $Count
    } else {
        Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    }
}