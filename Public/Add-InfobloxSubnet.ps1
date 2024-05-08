function Add-InfobloxSubnet {
    <#
    .SYNOPSIS
    Adds a subnet to Infoblox.

    .DESCRIPTION
    This function adds a subnet to Infoblox. It requires a connection to an Infoblox server, which can be established using the Connect-Infoblox function.

    .PARAMETER Subnet
    The subnet to add. This parameter is mandatory.

    .PARAMETER Comment
    An optional comment for the subnet.

    .PARAMETER NetworkView
    The network view in which to add the subnet. Defaults to 'default'.

    .PARAMETER AutoCreateReverseZone
    A switch that, when present, indicates that a reverse zone should be automatically created for the subnet.

    .PARAMETER DHCPGateway
    The DHCP gateway for the subnet.

    .PARAMETER DHCPLeaseTime
    The DHCP lease time for the subnet.

    .PARAMETER DHCPDomainNameServers
    The DHCP domain name servers for the subnet.

    .PARAMETER ReturnOutput
    A switch that, when present, indicates that the output of the command should be returned.

    .EXAMPLE
    Add-InfobloxSubnet -Subnet '192.168.1.0/24' -Comment 'Test subnet' -DHCPGateway '192.168.1.1'

    .NOTES
    This function requires a connection to an Infoblox server, which can be established using the Connect-Infoblox function.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string] $Subnet,
        [string] $Comment,
        [string] $NetworkView = 'default',
        [switch] $AutoCreateReverseZone,
        [string] $DHCPGateway,
        [string] $DHCPLeaseTime,
        [string] $DHCPDomainNameServers,
        [switch] $ReturnOutput
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfobloxSubnet - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $Body = [ordered] @{
        "network"                 = $Subnet
        # "members"                 = @(
        #     @{
        #         "_struct"  = "msdhcpserver"
        #         "ipv4addr" = ""
        #     }
        # )
        "comment"                 = $Comment
        "network_view"            = $NetworkView
        "auto_create_reversezone" = $AutoCreateReverseZone.IsPresent
    }

    Remove-EmptyValue -Hashtable $Body

    $DHCPOptions = @(
        if ($DHCPLeaseTime) {
            [ordered] @{
                "name"         = "dhcp-lease-time"
                "num"          = 51
                "use_option"   = $true
                "value"        = $DHCPLeaseTime
                "vendor_class" = "DHCP"
            }
        }
        # DNS servers (we will use default ones if not provided)
        if ($DHCPDomainNameServers) {
            @{
                "name"         = "domain-name-servers"
                "num"          = 6
                "use_option"   = $true
                "value"        = $DHCPDomainNameServers
                "vendor_class" = "DHCP"
            }
        }
        # DHCP servers (we will use default ones if not provided)
        if ($DHCPGateway) {
            @{
                "name"         = "routers"
                "num"          = 3
                "use_option"   = $true
                "value"        = $DHCPGateway
                "vendor_class" = "DHCP"
            }
        }
    )

    if ($DHCPOptions.Count -gt 0) {
        $Body["options"] = $DHCPOptions
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = "network"
        Method      = 'POST'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Add-InfobloxSubnet - $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}