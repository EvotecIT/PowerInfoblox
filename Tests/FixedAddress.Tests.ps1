Describe 'Microsoft DHCP fixed address mutations' {
    InModuleScope PowerInfoblox {
        BeforeAll {
            $script:previousDefaults = @{}
            foreach ($Key in $PSDefaultParameterValues.Keys) {
                $script:previousDefaults[$Key] = $PSDefaultParameterValues[$Key]
            }
        }

        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://grid.example.test/wapi/v2.9' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://grid.example.test/wapi/v2.9'
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = [pscredential]::new('user', [System.Security.SecureString]::new())
            Mock Invoke-RestMethod -MockWith { 'fixedaddress/reference' }
        }

        AfterAll {
            $Script:InfobloxConfiguration = $null
            $PSDefaultParameterValues.Clear()
            foreach ($Key in $script:previousDefaults.Keys) {
                $PSDefaultParameterValues[$Key] = $script:previousDefaults[$Key]
            }
        }

        It 'sends a fixed address and Microsoft server structure in the JSON body' {
            Add-InfobloxFixedAddress -IPv4Address '192.0.2.151' -MacAddress '02:00:5E:10:00:01' -Name 'test reservation' -Comment 'test reservation' -MicrosoftServer 'ms-dhcp.example.test'

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                if ($Uri -ne 'https://grid.example.test/wapi/v2.9/fixedaddress' -or $Method -ne 'POST') {
                    return $false
                }
                $Payload = $Body | ConvertFrom-Json
                $Payload.ipv4addr -eq '192.0.2.151' -and
                $Payload.mac -eq '02:00:5e:10:00:01' -and
                $Payload.name -eq 'test reservation' -and
                $Payload.comment -eq 'test reservation' -and
                $Payload.ms_server._struct -eq 'msdhcpserver' -and
                $Payload.ms_server.ipv4addr -eq 'ms-dhcp.example.test'
            }
        }

        It 'sends a DHCP reservation and Microsoft server structure in the JSON body' {
            Add-InfobloxDHCPReservation -IPv4Address '192.0.2.152' -MacAddress '02:00:5E:10:00:02' -Name 'test reservation' -Network '192.0.2.0/24' -Comment 'test reservation' -MicrosoftServer 'ms-dhcp.example.test'

            Should -Invoke -CommandName Invoke-RestMethod -Times 1 -ParameterFilter {
                if ($Uri -ne 'https://grid.example.test/wapi/v2.9/fixedaddress' -or $Method -ne 'POST') {
                    return $false
                }
                $Payload = $Body | ConvertFrom-Json
                $Payload.ipv4addr -eq '192.0.2.152' -and
                $Payload.mac -eq '02:00:5e:10:00:02' -and
                $Payload.network -eq '192.0.2.0/24' -and
                $Payload.name -eq 'test reservation' -and
                $Payload.comment -eq 'test reservation' -and
                $Payload.ms_server._struct -eq 'msdhcpserver' -and
                $Payload.ms_server.ipv4addr -eq 'ms-dhcp.example.test'
            }
        }
    }
}
