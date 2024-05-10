function Add-InfobloxNetworkExtensibleAttribute {
    <#
    .SYNOPSIS
    Adds an extensible attribute to a specified network in Infoblox.

    .DESCRIPTION
    This function adds an extensible attribute to a network in Infoblox.
    It requires an established connection to an Infoblox server, which can be done using the Connect-Infoblox function.
    The function checks if the specified network exists before attempting to add the extensible attribute.

    .PARAMETER Network
    The network to which the extensible attribute will be added. This parameter is mandatory.

    .PARAMETER Attribute
    The name of the extensible attribute to add. This parameter is mandatory.

    .PARAMETER Value
    The value of the extensible attribute to add. This parameter is mandatory.

    .EXAMPLE
    Add-InfobloxNetworkExtensibleAttribute -Network '192.168.1.0/24' -Attribute 'Location' -Value 'Data Center 1'
    Adds the 'Location' extensible attribute with the value 'Data Center 1' to the network '192.168.1.0/24'.

    .NOTES
    You must first connect to an Infoblox server using Connect-Infoblox before running this function.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][alias('Subnet')][string] $Network,
        [Parameter(Mandatory)][alias('ExtensinbleAttribute')][string] $Attribute,
        [Parameter(Mandatory)][alias('ExtensinbleAttributeValue')][string] $Value
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfobloxNetworkExtensibleAttribute - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $NetworkInformation = Get-InfobloxNetwork -Network $Network
    if (-not $NetworkInformation._ref) {
        Write-Warning -Message "Add-InfobloxNetworkExtensibleAttribute - Network $Network not found"
        return
    }

    $Body = [ordered] @{
        "extattrs+" = @{
            $Attribute = @{
                "value" = $Value
            }
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
        Write-Verbose -Message "Add-InfobloxNetworkExtensibleAttribute - $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}