Describe 'Schema-aware return fields across public getters' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            $script:previousDefaults = @{}
            foreach ($Key in $PSDefaultParameterValues.Keys) {
                $script:previousDefaults[$Key] = $PSDefaultParameterValues[$Key]
            }
        }

        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13' }
            $Script:InfobloxSchemaFields = $null
            $script:capturedUris = [System.Collections.Generic.List[string]]::new()
            $script:schemaFields = @()
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = $Script:InfobloxConfiguration.BaseUri
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = [pscredential]::new('user', (ConvertTo-SecureString 'pass' -AsPlainText -Force))
            $PSDefaultParameterValues['Invoke-InfobloxQuery:WebSession'] = [Microsoft.PowerShell.Commands.WebRequestSession]::new()

            Mock Invoke-RestMethod -MockWith {
                param($Uri)
                $UriText = [string] $Uri
                $script:capturedUris.Add($UriText)
                if ($UriText -match '\?_schema(?:&|$)') {
                    return [pscustomobject]@{ fields = $script:schemaFields }
                }
                [pscustomobject]@{ _ref = 'object/ref' }
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

        It '<Command> requests only preferred fields readable on the connected Grid' -TestCases @(
            @{ Command = 'Get-InfobloxDNSAuthZone'; Parameters = @{}; Readable = 'address'; Blocked = 'allow_active_dir' }
            @{ Command = 'Get-InfobloxDNSDelegatedZone'; Parameters = @{}; Readable = 'address'; Blocked = 'delegate_to' }
            @{ Command = 'Get-InfobloxGrid'; Parameters = @{}; Readable = 'name'; Blocked = 'vpn_port' }
            @{ Command = 'Get-InfobloxMember'; Parameters = @{}; Readable = 'host_name'; Blocked = 'node_info' }
            @{ Command = 'Get-InfobloxDHCPLease'; Parameters = @{}; Readable = 'address'; Blocked = 'fingerprint' }
            @{ Command = 'Get-InfobloxFixedAddress'; Parameters = @{ MacAddress = '00:11:22:33:44:55' }; Readable = 'mac'; Blocked = 'network_view' }
            @{ Command = 'Get-InfobloxDNSRecord'; Parameters = @{ Type = 'Host' }; Readable = 'name'; Blocked = 'aliases' }
            @{ Command = 'Get-InfobloxDNSRecord'; Parameters = @{ Type = 'PTR' }; Readable = 'ptrdname'; Blocked = 'aws_rte53_record_info' }
            @{ Command = 'Get-InfobloxDNSRecord'; Parameters = @{ Type = 'A' }; Readable = 'ipv4addr'; Blocked = 'cloud_info' }
            @{ Command = 'Get-InfobloxDNSRecordAll'; Parameters = @{}; Readable = 'name'; Blocked = 'dtc_obscured' }
        ) {
            $script:schemaFields = @(
                [pscustomobject]@{ name = $Readable; supports = 'r' }
                [pscustomobject]@{ name = $Blocked; supports = 'w' }
            )

            & $Command @Parameters | Out-Null

            $ObjectUri = @($script:capturedUris | Where-Object { $_ -notmatch '\?_schema(?:&|$)' }) | Select-Object -Last 1
            $ObjectUri | Should -Match "(?:\?|&)_return_fields=$Readable(?:&|$)"
            $ObjectUri | Should -Not -Match ([regex]::Escape($Blocked))
        }
    }
}
