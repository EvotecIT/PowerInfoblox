function Add-InfobloxSubnet {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string] $Subnet,
        [string] $Comment,
        [string] $NetworkView = 'default',
        [switch] $AutoCreateReverseZone,
        [string] $DHCPGateway,
        [string] $DHCPLeaseTime,
        [string] $DHCPDomainNameServers
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
        if (-not $Suppress) {
            $Output
        } else {
            Write-Verbose -Message "Add-InfobloxSubnet - $Output"
        }
    }
}