function Convert-BinaryToDecimal {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][string]$Binary
    )

    $i = 0
    do {
        $DottedDecimal += "." + [string]$([convert]::toInt32($Binary.substring($i, 8), 2))
        $i += 8
    } while ($i -le 24)

    $DottedDecimal.substring(1)
}