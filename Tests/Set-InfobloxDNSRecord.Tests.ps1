Describe 'Set-InfobloxDNSRecord' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13.8' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test/wapi/v2.13.8'
            $script:requestBody = $null
            $script:requestMethod = $null
            $script:requestUri = $null
            Mock Invoke-InfobloxQuery -MockWith {
                $script:requestBody = $Body
                $script:requestMethod = $Method
                $script:requestUri = $RelativeUri
                'record/reference'
            }
        }

        AfterAll {
            $Script:InfobloxConfiguration = $null
            $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:BaseUri')
        }

        It 'maps <Type> values to the <Field> WAPI field' -TestCases @(
            @{ Type = 'A';     Field = 'ipv4addr';       Value = '192.0.2.20' }
            @{ Type = 'AAAA';  Field = 'ipv6addr';       Value = '2001:db8::20' }
            @{ Type = 'CNAME'; Field = 'canonical';      Value = 'Target.Example.test' }
            @{ Type = 'HOST';  Field = 'name';           Value = 'Host.Example.test' }
            @{ Type = 'PTR';   Field = 'ptrdname';       Value = 'Ptr.Example.test' }
            @{ Type = 'MX';    Field = 'mail_exchanger'; Value = 'Mail.Example.test' }
            @{ Type = 'NS';    Field = 'nameserver';     Value = 'Ns1.Example.test' }
            @{ Type = 'TXT';   Field = 'text';           Value = 'Verification=AbC123' }
        ) {
            param($Type, $Field, $Value)

            $referenceID = "record:$($Type.ToLowerInvariant())/opaque:record.example.test/default"
            Set-InfobloxDNSRecord -ReferenceID $referenceID -Type $Type -Value $Value

            $script:requestMethod | Should -Be 'PUT'
            $script:requestUri | Should -Be $referenceID
            $script:requestBody.Keys | Should -Be @($Field)
            $script:requestBody[$Field] | Should -BeExactly $Value
            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'infers CNAME from ReferenceID when Type is omitted' {
            Set-InfobloxDNSRecord -ReferenceID 'record:cname/opaque:alias.example.test/default' -Value 'target.example.test'

            $script:requestBody.canonical | Should -Be 'target.example.test'
            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'supports the legacy Object alias together with ReferenceID' {
            Set-InfobloxDNSRecord -ReferenceID 'record:cname/opaque:alias.example.test/default' -Object 'target.example.test'

            $script:requestBody.canonical | Should -Be 'target.example.test'
            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'rejects a Type that does not match ReferenceID' {
            {
                Set-InfobloxDNSRecord -ReferenceID 'record:cname/opaque:alias.example.test/default' -Type A -Value '192.0.2.20'
            } | Should -Throw "*Type 'A' does not match record type 'CNAME'*"

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'requires Properties for a structured record type' {
            {
                Set-InfobloxDNSRecord -ReferenceID 'record:srv/opaque:_service._tcp.example.test/default' -Value 'target.example.test'
            } | Should -Throw "*requires the Properties parameter set*"

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'updates structured HOST data through Properties' {
            $properties = @{ ipv4addrs = @(@{ ipv4addr = '192.0.2.30' }) }

            Set-InfobloxDNSRecord -ReferenceID 'record:host/opaque:host.example.test/default' -Properties $properties

            $script:requestBody.ipv4addrs[0].ipv4addr | Should -Be '192.0.2.30'
            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'updates an arbitrary WAPI record type through Properties' {
            Set-InfobloxDNSRecord -ReferenceID 'record:srv/opaque:_service._tcp.example.test/default' -Properties @{
                target = 'host.example.test'
                port = 443
                priority = 10
                weight = 5
            }

            $script:requestBody.target | Should -Be 'host.example.test'
            $script:requestBody.port | Should -Be 443
            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'updates MX preference with the exchanger' {
            Set-InfobloxDNSRecord -ReferenceID 'record:mx/opaque:example.test/default' -Value 'mail.example.test' -Preference 20

            $script:requestBody.mail_exchanger | Should -Be 'mail.example.test'
            $script:requestBody.preference | Should -Be 20
        }

        It 'updates NS glue addresses with the nameserver' {
            Set-InfobloxDNSRecord -ReferenceID 'record:ns/opaque:example.test/default' -Value 'ns1.example.test' -Address '192.0.2.53', '2001:db8::53'

            $script:requestBody.nameserver | Should -Be 'ns1.example.test'
            $script:requestBody.addresses.Count | Should -Be 2
            $script:requestBody.addresses[1].address | Should -Be '2001:db8::53'
        }

        It 'clears NS glue addresses when an empty collection is supplied explicitly' {
            Set-InfobloxDNSRecord -ReferenceID 'record:ns/opaque:example.test/default' -Value 'ns1.example.test' -Address @()

            $script:requestBody.nameserver | Should -Be 'ns1.example.test'
            $script:requestBody.Contains('addresses') | Should -BeTrue
            @($script:requestBody.addresses).Count | Should -Be 0
        }

        It 'rejects an address family mismatch' {
            {
                Set-InfobloxDNSRecord -ReferenceID 'record:a/opaque:host.example.test/default' -Value '2001:db8::20'
            } | Should -Throw '*not a valid IPv4 address*'

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'rejects empty Properties' {
            {
                Set-InfobloxDNSRecord -ReferenceID 'record:host/opaque:host.example.test/default' -Properties @{}
            } | Should -Throw '*Properties cannot be empty*'

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'rejects a non-record ReferenceID' {
            {
                Set-InfobloxDNSRecord -ReferenceID 'network/opaque:192.0.2.0/24/default' -Value 'target.example.test'
            } | Should -Throw '*is not a DNS record WAPI object reference*'

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'does not send an update under WhatIf' {
            Set-InfobloxDNSRecord -ReferenceID 'record:cname/opaque:alias.example.test/default' -Value 'target.example.test' -WhatIf

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0 -Exactly
        }
    }
}
