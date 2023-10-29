function Get-InfobloxNetwork {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [string] $Network = '*',
        [string[]]$Properties,
        [switch] $Partial,
        [switch] $All
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxNetwork - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($All) {
        $ListNetworks = Invoke-InfobloxQuery -RelativeUri "network" -Method Get -QueryParameter @{
            _return_fields = 'extattrs,network,network_view'
        }
    } elseif ($Network -and $Partial.IsPresent) {
        $ListNetworks = Invoke-InfobloxQuery -RelativeUri "network" -Method Get -QueryParameter @{
            "network~"     = $Network
            _return_fields = 'extattrs,network,network_view'
        }
    } elseif ($Network) {
        $ListNetworks = Invoke-InfobloxQuery -RelativeUri "network" -Method Get -QueryParameter @{
            network        = $Network
            _return_fields = 'extattrs,network,network_view'
        }
    } else {
        return
    }

    $ExtraProperties = $false
    $AllNetworks = foreach ($FoundNetwork in $ListNetworks) {

        $FullInformation = Get-IPAddressRangeInformation -Network $FoundNetwork.network

        #$Cidr = $FoundNetwork.network.split('/')[1]
        $OutputData = [ordered] @{
            Network        = $FoundNetwork.network
            #Cidr                 = $Cidr
            #SubnetMask           = Convert-BinaryToDecimal -binary (Convert-CidrToBinary -cidr $cidr)
            #Gateway               = $SubQuery.extensible_attributes.Gateway
            #Extensible_attributes = $SubQuery.extensible_attributes
            NetworkRef     = $FoundNetwork._ref
            IP             = $FullInformation.IP                   # : 10.2.10.0
            NetworkLength  = $FullInformation.NetworkLength        # : 24
            SubnetMask     = $FullInformation.SubnetMask           # : 255.255.255.0
            NetworkAddress = $FullInformation.NetworkAddress       # : 10.2.10.0
            HostMin        = $FullInformation.HostMin              # : 10.2.10.1
            HostMax        = $FullInformation.HostMax              # : 10.2.10.254
            TotalHosts     = $FullInformation.TotalHosts           # : 256
            UsableHosts    = $FullInformation.UsableHosts          # : 254
            Broadcast      = $FullInformation.Broadcast            # : 10.2.10.255
            #BinaryIP             = $FullInformation.BinaryIP             # : 00001010000000100000101000000000
            #BinarySubnetMask     = $FullInformation.BinarySubnetMask     # : 11111111111111111111111100000000
            #BinaryNetworkAddress = $FullInformation.BinaryNetworkAddress # : 00001010000000100000101000000000
            #BinaryBroadcast      = $FullInformation.BinaryBroadcast      # : 00001010000000100000101011111111
        }
        foreach ($Extra in $FoundNetwork.extattrs.psobject.properties) {
            $ExtraProperties = $true
            $OutputData.Add($Extra.Name, $Extra.Value.value)
        }
        [PSCustomObject]$OutputData
    }
    if ($ExtraProperties) {
        $Properties = Select-Properties -Objects $AllNetworks -AllProperties
        $AllNetworks | Select-Object -Property $Properties
    } else {
        $AllNetworks
    }
}