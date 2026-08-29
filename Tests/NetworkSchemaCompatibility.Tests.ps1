Describe 'Get-InfobloxNetwork schema compatibility' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            $script:previousDefaults = @{}
            foreach ($Key in $PSDefaultParameterValues.Keys) {
                $script:previousDefaults[$Key] = $PSDefaultParameterValues[$Key]
            }
        }

        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://test.example/wapi/v2.9' }
            $Script:InfobloxSchemaFields = $null
            $script:capturedQueryParameter = $null
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = $Script:InfobloxConfiguration.BaseUri

            Mock Invoke-InfobloxQuery -MockWith {
                param($QueryParameter)
                $script:capturedQueryParameter = $QueryParameter
                @()
            }
        }

        AfterEach {
            $Script:InfobloxConfiguration = $null
            $Script:InfobloxSchemaFields = $null
        }

        AfterAll {
            $PSDefaultParameterValues.Clear()
            foreach ($Key in $script:previousDefaults.Keys) {
                $PSDefaultParameterValues[$Key] = $script:previousDefaults[$Key]
            }
        }

        It 'omits preferred fields that are not readable in an older schema' {
            Mock Get-InfobloxSchema -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'network'; supports = 'r' }
                        [pscustomobject]@{ name = 'comment'; supports = 'rw' }
                        [pscustomobject]@{ name = 'vlans'; supports = 'w' }
                    )
                }
            }

            $null = Get-InfobloxNetwork -All

            $script:capturedQueryParameter._return_fields | Should -Be 'comment,network'
            Should -Invoke -CommandName Get-InfobloxSchema -Times 1 -Exactly
        }

        It 'includes preferred fields that are readable in a newer schema' {
            $Script:InfobloxConfiguration.BaseUri = 'https://production.example/wapi/v2.14'
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = $Script:InfobloxConfiguration.BaseUri
            Mock Get-InfobloxSchema -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'network'; supports = 'r' }
                        [pscustomobject]@{ name = 'comment'; supports = 'rw' }
                        [pscustomobject]@{ name = 'vlans'; supports = 'rwu' }
                    )
                }
            }

            $null = Get-InfobloxNetwork -All

            $script:capturedQueryParameter._return_fields | Should -Be 'comment,network,vlans'
        }

        It 'adapts to the readable fields exposed by an intermediate schema' {
            $Script:InfobloxConfiguration.BaseUri = 'https://staging.example/wapi/v2.13'
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = $Script:InfobloxConfiguration.BaseUri
            Mock Get-InfobloxSchema -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'network'; supports = 'r' }
                        [pscustomobject]@{ name = 'discovered_vlan_id'; supports = 'r' }
                    )
                }
            }

            $null = Get-InfobloxNetwork -All

            $script:capturedQueryParameter._return_fields | Should -Be 'discovered_vlan_id,network'
        }

        It 'keeps schema caches separate for different endpoints' {
            Mock Get-InfobloxSchema -MockWith {
                if ($Script:InfobloxConfiguration.BaseUri -like '*v2.9') {
                    [pscustomobject]@{
                        fields = @(
                            [pscustomobject]@{ name = 'network'; supports = 'r' }
                        )
                    }
                } else {
                    [pscustomobject]@{
                        fields = @(
                            [pscustomobject]@{ name = 'network'; supports = 'r' }
                            [pscustomobject]@{ name = 'vlans'; supports = 'r' }
                        )
                    }
                }
            }

            $testFields = Get-FieldsFromSchema -SchemaObject 'network'
            $Script:InfobloxConfiguration.BaseUri = 'https://production.example/wapi/v2.14'
            $productionFields = Get-FieldsFromSchema -SchemaObject 'network'
            $productionFieldsAgain = Get-FieldsFromSchema -SchemaObject 'network'

            $testFields | Should -Be 'network'
            $productionFields | Should -Be 'network,vlans'
            $productionFieldsAgain | Should -Be 'network,vlans'
            Should -Invoke -CommandName Get-InfobloxSchema -Times 2 -Exactly
        }

        It 'returns every readable schema field with FetchFromSchema' {
            Mock Get-InfobloxSchema -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'network'; supports = 'r' }
                        [pscustomobject]@{ name = 'future_feature'; supports = 'r' }
                        [pscustomobject]@{ name = 'write_only'; supports = 'w' }
                    )
                }
            }

            $null = Get-InfobloxNetwork -All -FetchFromSchema

            $script:capturedQueryParameter._return_fields | Should -Be 'network,future_feature'
        }

        It 'falls back to server default fields when schema discovery throws under stop preference' {
            Mock Get-InfobloxSchema -MockWith { throw 'Schema access denied' }
            Mock Write-Warning

            { $null = Get-InfobloxNetwork -All -ErrorAction Stop } | Should -Not -Throw

            $script:capturedQueryParameter.Contains('_return_fields') | Should -BeFalse
            Should -Invoke -CommandName Write-Warning -Times 1 -ParameterFilter {
                $Message -eq "Get-FieldsFromSchema - Failed to fetch schema for record type 'network'. Using server default fields"
            }
        }

        It 'trusts explicitly requested return fields without schema discovery' {
            Mock Get-InfobloxSchema

            $null = Get-InfobloxNetwork -All -ReturnFields @('network', 'comment', 'comment')

            $script:capturedQueryParameter._return_fields | Should -Be 'comment,network'
            Should -Invoke -CommandName Get-InfobloxSchema -Times 0 -Exactly
        }

        It 'uses server default fields for Native requests without schema discovery' {
            Mock Get-InfobloxSchema

            $null = Get-InfobloxNetwork -All -Native

            $script:capturedQueryParameter.Contains('_return_fields') | Should -BeFalse
            Should -Invoke -CommandName Get-InfobloxSchema -Times 0 -Exactly
        }
    }
}
