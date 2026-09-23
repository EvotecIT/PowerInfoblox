function Add-InfoBloxDNSRecord {
    <#
    .SYNOPSIS
    Creates an Infoblox DNS record.

    .DESCRIPTION
    Creates a typed A, AAAA, CNAME, HOST, PTR, MX, NS, or TXT record. Other WAPI
    DNS record types can be created by supplying their fields through Properties.

    .PARAMETER Name
    The record name. PTR records created from an IP address do not require Name.

    .PARAMETER IPAddress
    The IPv4 or IPv6 address used by A, AAAA, HOST, and reverse-mapping PTR records.

    .PARAMETER CanonicalName
    The canonical target of a CNAME record.

    .PARAMETER PtrName
    The target domain name of a PTR record.

    .PARAMETER Text
    The exact TXT record value. Character casing is preserved.

    .PARAMETER MailExchanger
    The mail exchanger of an MX record.

    .PARAMETER Preference
    The MX preference from 0 through 65535.

    .PARAMETER NameServer
    The authoritative server name of an NS record.

    .PARAMETER Address
    Optional IPv4 or IPv6 glue addresses for an NS record. Omit this parameter when
    the nameserver does not require glue.

    .PARAMETER Properties
    A field dictionary for a WAPI DNS record type that does not use the typed parameters.

    .PARAMETER Type
    The WAPI DNS record type. The legacy LBDN name is normalized to DTCLBDN.

    .PARAMETER View
    The DNS view in which to create a typed record. When omitted, WAPI uses its default view.

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name 'host.example.com' -IPv4Address '192.0.2.10' -Type A

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name 'alias.example.com' -CanonicalName 'host.example.com' -Type CNAME

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name '5.10.2.10.in-addr.arpa' -PtrName 'host.example.com' -Type PTR -View Internal

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name 'example.com' -MailExchanger 'mail.example.com' -Preference 10 -Type MX

    .EXAMPLE
    Add-InfoBloxDNSRecord -Type SRV -Properties @{ name = '_service._tcp.example.com'; target = 'host.example.com'; port = 443; priority = 10; weight = 5 }
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Typed')]
    param(
        [Parameter(ParameterSetName = 'Typed')]
        [string] $Name,

        [Alias('IPv4Address', 'IPv6Address')]
        [Parameter(ParameterSetName = 'Typed')]
        [string] $IPAddress,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $CanonicalName,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $PtrName,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $Text,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $MailExchanger,

        [Parameter(ParameterSetName = 'Typed')]
        [ValidateRange(0, 65535)]
        [int] $Preference,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $NameServer,

        [Alias('Addresses')]
        [Parameter(ParameterSetName = 'Typed')]
        [string[]] $Address,

        [Parameter(Mandatory, ParameterSetName = 'Properties')]
        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Type,

        [Parameter(ParameterSetName = 'Typed')]
        [ValidateNotNullOrEmpty()]
        [string] $View
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfoBloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Type
    $bodySplat = @{
        Type = $NormalizedType
    }
    if ($PSCmdlet.ParameterSetName -eq 'Properties') {
        $bodySplat.Properties = $Properties
    } else {
        foreach ($ParameterName in @('Name', 'IPAddress', 'CanonicalName', 'PtrName', 'Text', 'MailExchanger', 'Preference', 'NameServer', 'Address')) {
            if ($PSBoundParameters.ContainsKey($ParameterName)) {
                $bodySplat[$ParameterName] = $PSBoundParameters[$ParameterName]
            }
        }
        if ($PSBoundParameters.ContainsKey('Preference')) {
            $bodySplat.PreferenceSpecified = $true
        }
    }

    try {
        $Body = ConvertTo-InfobloxDNSRecordCreateBody @bodySplat -ErrorAction Stop
    } catch {
        if ($ErrorActionPreference -eq 'Stop') {
            throw
        }
        Write-Warning -Message $_.Exception.Message
        return
    }

    if ($PSBoundParameters.ContainsKey('View')) {
        $Body.view = $View
    }

    $TargetName = if ($Name) { $Name } elseif ($Properties -and $Properties.Contains('name')) { $Properties['name'] } else { "record:$NormalizedType" }
    if (-not $PSCmdlet.ShouldProcess($TargetName, "Add $($NormalizedType.ToUpperInvariant()) DNS record")) {
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = "record:$NormalizedType"
        Method      = 'POST'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -Confirm:$false
    if ($Output) {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Added $($NormalizedType.ToUpperInvariant()) / $Output"
    }
}
