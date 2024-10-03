function Set-InfobloxDNSRecord {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER ReferenceID
    Parameter description

    .PARAMETER Object
    Parameter description

    .PARAMETER Type
    Parameter description

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:host/ZG5zLmhvc3QkLl9kZWZhdWx0LmNvbS5teW5ldC5jb20kMTAuMTAuMTAuMTA=' -Name 'xyz' -Type 'A'

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:host/ZG5zLmhvc3QkLl9kZWZhdWx0LmNvbS5teW5ldC5jb20kMTAuMTAuMTAuMTA=' -PTRName 'xyz -Type 'PTR'

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:host/ZG5zLmhvc3QkLl9kZWZhdWx0LmNvbS5teW5ldC5jb20kMTAuMTAuMTAuMTA=' -Name 'test2.mcdonalds.com' -Type 'CNAME'

    .NOTES
    General notes
    #>#
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ReferenceID')]
    param(
        [parameter(ParameterSetName = 'ReferenceID', Mandatory)][string] $ReferenceID,
        [Alias("Name", 'PtrName', 'PTR', 'NameServer', 'Text')][parameter(ParameterSetName = 'Object', Mandatory)][string] $Object,
        [parameter(Mandatory)][ValidateSet(
            'A',
            'AAAA',
            'CNAME',
            'HOST',
            'PTR',
            'MX',
            'NS',
            'TXT'
        )][string] $Type
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Set-InfobloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # Lets convert it to lowercase, since Infoblox is case sensitive
    $Type = $Type.ToLower()
    if ($Type -in 'A', 'AAAA', 'HOST', 'CNAME', 'MX') {
        $Body = [ordered] @{
            name = $Object.ToLower()
        }
    } elseif ($Type -eq 'PTR') {
        $Body = [ordered] @{
            ptrdname = $Object.ToLower()
        }
    } elseif ($Type -eq 'NS') {
        $Body = [ordered] @{
            nameserver = $Object.ToLower()
        }
    } elseif ($Type -eq 'TXT') {
        $Body = [ordered] @{
            text = $Object.ToLower()
        }
    } else {
        if ($ErrorActionPreference -eq 'Stop') {
            throw "Set-InfobloxDNSRecord - Unsupported type: $Type"
        }
        Write-Warning -Message "Set-InfobloxDNSRecord - Unsupported type: $Type"
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = $ReferenceID
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Set-InfobloxDNSRecord - Modified $Type / $Output"
    }
}