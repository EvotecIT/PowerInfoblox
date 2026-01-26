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

Describe 'EA definition lookup fallback' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            $moduleBase = (Get-Module PowerInfoblox).ModuleBase
            . (Join-Path $moduleBase 'Private\Get-InfobloxExtensibleAttributeDefinition.ps1')

            $script:previousDefaults = @{}
            foreach ($Key in $PSDefaultParameterValues.Keys) {
                $script:previousDefaults[$Key] = $PSDefaultParameterValues[$Key]
            }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test'
        }

        AfterAll {
            $PSDefaultParameterValues.Clear()
            foreach ($Key in $script:previousDefaults.Keys) {
                $PSDefaultParameterValues[$Key] = $script:previousDefaults[$Key]
            }
        }

        It 'retries without return_fields when the first call throws' {
            $script:invokeCalls = @()
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $QueryParameter)
                $clonedQuery = @{}
                if ($QueryParameter) {
                    foreach ($Key in $QueryParameter.Keys) {
                        $clonedQuery[$Key] = $QueryParameter[$Key]
                    }
                }
                $script:invokeCalls += [pscustomobject]@{ QueryParameter = $clonedQuery }
                if ($script:invokeCalls.Count -eq 1) {
                    throw 'Bad request'
                }
                [pscustomobject]@{ name = 'VLAN'; list_values = @() }
            }

            $null = Get-InfobloxExtensibleAttributeDefinition -Name 'VLAN' -SkipCache

            $script:invokeCalls.Count | Should -Be 2
            $script:invokeCalls[0].QueryParameter.ContainsKey('_return_fields') | Should -BeTrue
            $script:invokeCalls[1].QueryParameter.ContainsKey('_return_fields') | Should -BeFalse
        }

        It 'does not retry when the response is an empty array' {
            $script:invokeCalls = @()
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $QueryParameter)
                $clonedQuery = @{}
                if ($QueryParameter) {
                    foreach ($Key in $QueryParameter.Keys) {
                        $clonedQuery[$Key] = $QueryParameter[$Key]
                    }
                }
                $script:invokeCalls += [pscustomobject]@{ QueryParameter = $clonedQuery }
                return @()
            }

            $null = Get-InfobloxExtensibleAttributeDefinition -Name 'Missing' -SkipCache

            $script:invokeCalls.Count | Should -Be 1
        }

        It 'retries even when the first call throws and ErrorActionPreference is Stop' {
            $script:invokeCalls = @()
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $QueryParameter)
                $clonedQuery = @{}
                if ($QueryParameter) {
                    foreach ($Key in $QueryParameter.Keys) {
                        $clonedQuery[$Key] = $QueryParameter[$Key]
                    }
                }
                $script:invokeCalls += [pscustomobject]@{ QueryParameter = $clonedQuery }
                if ($script:invokeCalls.Count -eq 1) {
                    throw 'Bad request'
                }
                [pscustomobject]@{ name = 'VLAN'; list_values = @() }
            }

            $previous = $ErrorActionPreference
            $ErrorActionPreference = 'Stop'
            try {
                $null = Get-InfobloxExtensibleAttributeDefinition -Name 'VLAN' -SkipCache
            } finally {
                $ErrorActionPreference = $previous
            }

            $script:invokeCalls.Count | Should -Be 2
            $script:invokeCalls[1].QueryParameter.ContainsKey('_return_fields') | Should -BeFalse
        }
    }
}
