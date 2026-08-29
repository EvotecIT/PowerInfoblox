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
