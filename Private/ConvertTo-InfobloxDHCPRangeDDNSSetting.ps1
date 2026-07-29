function ConvertTo-InfobloxDHCPRangeDDNSSetting {
    [CmdletBinding()]
    param(
        [ValidateSet('Inherit', 'Override')]
        [string] $DDNSUpdateMode,

        [Nullable[bool]] $DDNSEnabled
    )

    $Setting = [ordered] @{}
    if ($DDNSUpdateMode) {
        $Setting['use_enable_ddns'] = $DDNSUpdateMode -eq 'Override'
    }
    if ($null -ne $DDNSEnabled) {
        if ($DDNSUpdateMode -eq 'Inherit') {
            throw 'DDNSEnabled cannot be set when DDNSUpdateMode is Inherit.'
        }
        $Setting['use_enable_ddns'] = $true
        $Setting['enable_ddns'] = [bool] $DDNSEnabled
    }
    $Setting
}
