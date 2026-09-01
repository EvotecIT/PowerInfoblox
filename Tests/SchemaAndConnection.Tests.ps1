Describe 'Infoblox schema requests' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            $script:previousDefaults = @{}
            foreach ($Key in $PSDefaultParameterValues.Keys) {
                $script:previousDefaults[$Key] = $PSDefaultParameterValues[$Key]
            }
        }

        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13.8' }
            $Script:InfobloxSchemaFields = $null
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test/wapi/v2.13.8'
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = [pscredential]::new('user', (ConvertTo-SecureString 'pass' -AsPlainText -Force))
            $PSDefaultParameterValues['Invoke-InfobloxQuery:WebSession'] = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
            Mock Invoke-RestMethod -MockWith {
                [pscustomobject]@{
                    fields = @()
                    type   = 'networkcontainer'
                }
            }
        }

        AfterAll {
            $Script:InfobloxConfiguration = $null
            $PSDefaultParameterValues.Clear()
            foreach ($Key in $script:previousDefaults.Keys) {
                $PSDefaultParameterValues[$Key] = $script:previousDefaults[$Key]
            }
        }

        It 'uses the valueless schema option for object schema requests' {
            $null = Get-InfobloxSchema -Object 'NetworkContainer'

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                $Uri -eq 'https://example.test/wapi/v2.13.8/networkcontainer?_schema'
            }
        }

        It 'supports readable root schema fields without an object argument' {
            Mock Invoke-RestMethod -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'supported_objects'; supports = 'r' }
                    )
                }
            }

            $fields = Get-InfobloxSchema -ReturnReadOnlyFields

            $fields | Should -Be 'supported_objects'
        }

        It 'returns writable fields without issuing a second schema request' {
            Mock Invoke-RestMethod -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'read_only'; supports = 'r' }
                        [pscustomobject]@{ name = 'read_write'; supports = 'rw' }
                        [pscustomobject]@{ name = 'write_only'; supports = 'w' }
                    )
                }
            }

            $fields = Get-InfobloxSchema -Object 'network' -ReturnWriteFields

            $fields | Should -Be 'read_write,write_only'
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly
        }

        It 'returns field objects without issuing a second schema request' {
            Mock Invoke-RestMethod -MockWith {
                [pscustomobject]@{
                    fields = @(
                        [pscustomobject]@{ name = 'network'; supports = 'r' }
                    )
                }
            }

            $fields = @(Get-InfobloxSchema -Object 'network' -ReturnFields)

            $fields | Should -HaveCount 1
            $fields[0].name | Should -Be 'network'
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -Exactly
        }

        It 'omits empty return field parameters while preserving other query values' {
            $script:capturedUri = $null
            Mock Invoke-RestMethod -MockWith {
                param($Uri)
                $script:capturedUri = [string] $Uri
                @()
            }

            $null = Invoke-InfobloxQuery -RelativeUri 'range' -QueryParameter ([ordered]@{
                    _return_fields  = $null
                    '_return_fields+' = '   '
                    network_view    = 'default'
                    _max_results    = 1000
                }) -WhatIf:$false

            $script:capturedUri | Should -Not -Match '_return_fields'
            $script:capturedUri | Should -Match 'network_view=default'
            $script:capturedUri | Should -Match '_max_results=1000'
        }

        It 'reports the object type when schema retrieval fails' {
            Mock Get-InfobloxSchema
            Mock Write-Warning

            $null = Get-FieldsFromSchema -SchemaObject 'networkcontainer'

            Should -Invoke -CommandName Write-Warning -Times 1 -ParameterFilter {
                $Message -eq "Get-FieldsFromSchema - Failed to fetch schema for record type 'networkcontainer'. Using server default fields"
            }
        }
    }
}

Describe 'Infoblox request timeout' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            $script:previousDefaults = @{}
            foreach ($Key in $PSDefaultParameterValues.Keys) {
                $script:previousDefaults[$Key] = $PSDefaultParameterValues[$Key]
            }
            $script:testCredential = [pscredential]::new('user', (ConvertTo-SecureString 'pass' -AsPlainText -Force))
        }

        BeforeEach {
            Disconnect-Infoblox
            Mock Invoke-RestMethod -MockWith { [pscustomobject]@{ ok = $true } }
        }

        AfterAll {
            Disconnect-Infoblox
            $PSDefaultParameterValues.Clear()
            foreach ($Key in $script:previousDefaults.Keys) {
                $PSDefaultParameterValues[$Key] = $script:previousDefaults[$Key]
            }
        }

        It 'uses 600 seconds by default' {
            Connect-Infoblox -Server 'example.test' -Credential $script:testCredential -SkipInitialConnection

            $null = Invoke-InfobloxQuery -RelativeUri 'network'

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter { $TimeoutSec -eq 600 }
        }

        It 'uses the timeout configured by Connect-Infoblox' {
            $connection = Connect-Infoblox -Server 'example.test' -Credential $script:testCredential -TimeoutSec 3600 -SkipInitialConnection -ReturnObject

            $null = Invoke-InfobloxQuery -RelativeUri 'network'

            $connection.TimeoutSec | Should -Be 3600
            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter { $TimeoutSec -eq 3600 }
        }

        It 'allows a request to override the connection timeout' {
            Connect-Infoblox -Server 'example.test' -Credential $script:testCredential -TimeoutSec 3600 -SkipInitialConnection

            $null = Invoke-InfobloxQuery -RelativeUri 'network' -TimeoutSec 30

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter { $TimeoutSec -eq 30 }
        }

        It 'clears the configured timeout when disconnecting' {
            Connect-Infoblox -Server 'example.test' -Credential $script:testCredential -TimeoutSec 3600 -SkipInitialConnection
            $Script:InfobloxSchemaFields = [ordered] @{ network = @('network') }

            Disconnect-Infoblox

            $PSDefaultParameterValues.ContainsKey('Invoke-InfobloxQuery:TimeoutSec') | Should -BeFalse
            $Script:InfobloxSchemaFields | Should -BeNullOrEmpty
        }
    }
}
