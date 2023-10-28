function Convert-CidrToBinary {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)][int]$Cidr
    )

    $CidrBin = [string]::Empty

    if ($Cidr -le 32) {
        [int[]]$List = (1..32)
        for ($i = 0; $i -lt $List.length; $i++) {
            if ($List[$i] -gt $Cidr) {
                $List[$i] = '0'
            } else {
                $List[$i] = '1'
            }
        }
        $CidrBin = $List -join ''
    }
    $CidrBin
}