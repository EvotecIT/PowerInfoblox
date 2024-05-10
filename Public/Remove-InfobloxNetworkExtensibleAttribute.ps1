function Remove-InfobloxNetworkExtensibleAttribute {
    <#
    .SYNOPSIS
    Removes an extensible attribute from a specified network in Infoblox.

    .DESCRIPTION
    This function removes an extensible attribute from a network in Infoblox.
    It requires an established connection to an Infoblox server, which can be done using the Connect-Infoblox function.
    The function checks if the specified network exists before attempting to remove the extensible attribute.

    .PARAMETER Network
    The network from which the extensible attribute will be removed. This parameter is mandatory.

    .PARAMETER Attribute
    The name of the extensible attribute to remove. This parameter is mandatory.

    .EXAMPLE
    Remove-InfobloxNetworkExtensibleAttribute -Network '192.168.1.0/24' -Attribute 'Location'
    Removes the 'Location' extensible attribute from the network '192.168.1.0/24'.

    .NOTES
    You must first connect to an Infoblox server using Connect-Infoblox before running this function.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][alias('Subnet')][string] $Network,
        [Parameter(Mandatory)][alias('ExtensibleAttribute')][string] $Attribute
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Remove-InfobloxNetworkExtensibleAttribute - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $NetworkInformation = Get-InfobloxNetwork -Network $Network
    if (-not $NetworkInformation._ref) {
        Write-Warning -Message "Remove-InfobloxNetworkExtensibleAttribute - Network $Network not found"
        return
    }
    $Body = [ordered] @{
        "extattrs-" = @{
            $Attribute = @{}
        }
    }

    Remove-EmptyValue -Hashtable $Body

    $invokeInfobloxQuerySplat = @{
        RelativeUri = $NetworkInformation._ref
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Remove-InfobloxNetworkExtensibleAttribute - $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}