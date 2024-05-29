function Add-InfobloxNetwork {
    <#
    .SYNOPSIS
    Adds a network to Infoblox.

    .DESCRIPTION
    This function adds a network to Infoblox. It requires a connection to an Infoblox server, which can be established using the Connect-Infoblox function.

    .PARAMETER Network
    The network to add. This parameter is mandatory.

    .PARAMETER Comment
    An optional comment for the network.

    .PARAMETER NetworkView
    The network view in which to add the network. Defaults to 'default'.

    .PARAMETER AutoCreateReverseZone
    A switch that, when present, indicates that a reverse zone should be automatically created for the network.

    .PARAMETER DHCPGateway
    The DHCP gateway for the network.

    .PARAMETER DHCPLeaseTime
    The DHCP lease time for the network.

    .PARAMETER DHCPDomainNameServers
    The DHCP domain name servers for the network.

    .PARAMETER Options
    An array of options to be added to the DHCP range.

    .PARAMETER ExtensibleAttributeName
    The name of an extensible attribute for the network.

    .PARAMETER ExtensibleAttributeSite
    The site associated with the network as an extensible attribute.

    .PARAMETER ExtensibleAttributeState
    The state associated with the network as an extensible attribute.

    .PARAMETER ExtensibleAttributeCountry
    The country associated with the network as an extensible attribute.

    .PARAMETER ExtensibleAttributeRegion
    The region associated with the network as an extensible attribute.

    .PARAMETER ExtensibleAttributeVLAN
    The VLAN associated with the network as an extensible attribute.

    .PARAMETER ExtensibleAttribute
    A hashtable of additional extensible attributes to associate with the network.

    .PARAMETER Members
    An array of DHCP members to associate with the network.

    .PARAMETER ReturnOutput
    A switch that, when present, indicates that the output of the command should be returned.

    .EXAMPLE
    Add-InfobloxNetwork -Network '192.168.1.0/24' -Comment 'Test network' -DHCPGateway '192.168.1.1'

    .EXAMPLE
    $addInfobloxSubnetSplat = @{
        Subnet                      = '10.22.35.0/24'
        Comment                     = "Oki dokii"
        AutoCreateReverseZone       = $true
        DHCPGateway                 = "10.22.35.1"
        DHCPLeaseTime               = 5000
        DHCPDomainNameServers       = "192.168.4.56,192.168.4.57"
        ExtensinbleAttributeCountry = "Poland"
        ExtensinbleAttributeName    = "Test"
        ExtensinbleAttributeRegion  = "Europe"
        ExtensinbleAttributeSite    = "Site1"
        ExtensinbleAttributeState   = "Mazowieckie"
        ExtensinbleAttributeVLAN    = "810"
    }

    Add-InfobloxNetwork @addInfobloxSubnetSplat

    .EXAMPLE
    $addInfobloxSubnetSplat = @{
        Subnet                = '10.22.36.0/24'
        Comment               = "Oki dokii"
        AutoCreateReverseZone = $true
        DHCPGateway           = "10.22.36.1"
        DHCPLeaseTime         = 5000
        DHCPDomainNameServers = "192.168.4.56,192.168.4.57"
        ExtensinbleAttribute  = [ordered] @{
            Name    = 'Test'
            VLAN    = '810'
            Country = 'Poland'
            Region  = 'Europe'
            Site    = 'Site1'
        }
    }

    Add-InfobloxNetwork @addInfobloxSubnetSplat

    .NOTES
    This function requires a connection to an Infoblox server, which can be established using the Connect-Infoblox function.
    #>
    [alias('Add-InfobloxSubnet')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][alias('Subnet')][string] $Network,
        [string] $Comment,
        [string] $NetworkView = 'default',
        [switch] $AutoCreateReverseZone,
        [string] $DHCPGateway,
        [string] $DHCPLeaseTime,
        [string] $DHCPDomainNameServers,
        [Array] $Options,
        [string[]] $Members,
        [string] $ExtensinbleAttributeName,
        [string] $ExtensinbleAttributeSite,
        [string] $ExtensinbleAttributeState,
        [string] $ExtensinbleAttributeCountry,
        [string] $ExtensinbleAttributeRegion,
        [string] $ExtensinbleAttributeVLAN,
        [System.Collections.IDictionary] $ExtensinbleAttribute,
        [switch] $ReturnOutput
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfobloxNetwork - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $Body = [ordered] @{
        "network"                 = $Network
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

    if ($Members) {
        $Body["members"] = @(
            foreach ($DHCPMember in $Members) {
                [ordered] @{
                    "_struct"  = "msdhcpserver"
                    "ipv4addr" = $DHCPMember
                }
            }
        )
        #"_struct": "dhcpmember",
        #"name": "ddi.example.com"
    }

    $DHCPOptions = @(
        if ($Options) {
            foreach ($Option in $Options) {
                $Option
            }
        }
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

    # Lets add extensible attributes
    $ExtensibleAttributeExists = $false
    foreach ($Key in $PSBoundParameters.Keys) {
        if ($Key -like "ExtensinbleAttribute*") {
            $ExtensibleAttributeExists = $true
            break
        }
    }
    if ($ExtensibleAttributeExists) {
        $Body["extattrs"] = [ordered] @{}
        if ($ExtensinbleAttributeName) {
            $Body["extattrs"]["Name"] = @{
                value = $ExtensinbleAttributeName
            }
        }
        if ($ExtensinbleAttributeSite) {
            $Body["extattrs"]["Site"] = @{
                value = $ExtensinbleAttributeSite
            }
        }
        if ($ExtensinbleAttributeState) {
            $Body["extattrs"]["State"] = @{
                value = $ExtensinbleAttributeState
            }
        }
        if ($ExtensinbleAttributeCountry) {
            $Body["extattrs"]["Country"] = @{
                value = $ExtensinbleAttributeCountry
            }
        }
        if ($ExtensinbleAttributeRegion) {
            $Body["extattrs"]["Region"] = @{
                value = $ExtensinbleAttributeRegion
            }
        }
        if ($ExtensinbleAttributeVLAN) {
            $Body["extattrs"]["VLAN"] = @{
                value = $ExtensinbleAttributeVLAN
            }
        }
        foreach ($Key in $ExtensinbleAttribute.Keys) {
            if ($ExtensinbleAttribute[$Key] -is [System.Collections.IDictionary]) {
                $Body["extattrs"][$Key] = $ExtensinbleAttribute[$Key]
            } else {
                $Body["extattrs"][$Key] = @{
                    value = $ExtensinbleAttribute[$Key]
                }
            }
        }
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = "network"
        Method      = 'POST'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Add-InfobloxNetwork - $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}