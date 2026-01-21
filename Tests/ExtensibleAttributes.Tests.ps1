Describe 'Extensible Attributes resolution' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            Mock Get-InfobloxExtensibleAttributeDefinition -MockWith {
                param($Name)
                switch ($Name) {
                    'NetworkType' {
                        [pscustomobject]@{
                            name        = 'NetworkType'
                            list_values = @(
                                [pscustomobject]@{ value = 'on-prem SDC'; id = 'eaid-nt-001' }
                                [pscustomobject]@{ value = 'cloud'; id = 'eaid-nt-002' }
                            )
                        }
                    }
                    'Support group' {
                        [pscustomobject]@{
                            name        = 'Support group'
                            list_values = @(
                                [pscustomobject]@{ value = 'Tier1'; id = 'eaid-sg-001' }
                                [pscustomobject]@{ value = 'Tier2'; id = 'eaid-sg-002' }
                            )
                        }
                    }
                    Default {
                        [pscustomobject]@{
                            name        = $Name
                            list_values = $null
                        }
                    }
                }
            }
        }

        It 'resolves list display value to internal id' {
            $extattrs = ConvertTo-InfobloxExtattrs -Attributes @{
                NetworkType = 'on-prem SDC'
            }
            $extattrs.NetworkType.value | Should -Be 'eaid-nt-001'
        }

        It 'passes through internal id without changes' {
            $extattrs = ConvertTo-InfobloxExtattrs -Attributes @{
                NetworkType = 'eaid-nt-001'
            }
            $extattrs.NetworkType.value | Should -Be 'eaid-nt-001'
        }

        It 'resolves multiple list values to ids' {
            $extattrs = ConvertTo-InfobloxExtattrs -Attributes @{
                'Support group' = @('Tier1', 'Tier2')
            }
            $extattrs.'Support group'.value | Should -Be @('eaid-sg-001', 'eaid-sg-002')
        }

        It 'resolves values when extattrs are passed as dictionary' {
            $extattrs = ConvertTo-InfobloxExtattrs -Attributes @{
                NetworkType = @{
                    values = @('on-prem SDC')
                }
            }
            $extattrs.NetworkType.values | Should -Be @('eaid-nt-001')
        }

        It 'throws when list value is not found and ErrorActionPreference is Stop' {
            $previous = $ErrorActionPreference
            $ErrorActionPreference = 'Stop'
            try {
                { ConvertTo-InfobloxExtattrs -Attributes @{ NetworkType = 'missing-value' } } | Should -Throw
            } finally {
                $ErrorActionPreference = $previous
            }
        }
    }
}
