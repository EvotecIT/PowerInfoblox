function Test-InfobloxDNSRecordValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Type,

        [AllowNull()]
        [object] $ActualValue,

        [Parameter(Mandatory)]
        [string] $ExpectedValue
    )

    if ($null -eq $ActualValue) {
        return $false
    }
    $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Type
    if ($NormalizedType -eq 'txt') {
        return ([string] $ActualValue) -ceq $ExpectedValue
    }
    if ($NormalizedType -in @('a', 'aaaa')) {
        $ActualAddress = $null
        $ExpectedAddress = $null
        return [System.Net.IPAddress]::TryParse([string] $ActualValue, [ref] $ActualAddress) -and
            [System.Net.IPAddress]::TryParse($ExpectedValue, [ref] $ExpectedAddress) -and
            $ActualAddress.Equals($ExpectedAddress)
    }
    return ([string] $ActualValue).TrimEnd('.') -ieq $ExpectedValue.TrimEnd('.')
}
