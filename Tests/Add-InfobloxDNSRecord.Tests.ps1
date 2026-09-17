Describe 'Add-InfoBloxDNSRecord' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13.8' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = $Script:InfobloxConfiguration.BaseUri
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

        It 'creates <Type> with the correct WAPI shape' -TestCases @(
            @{ Type = 'A'; Parameters = @{ Name = 'host.example.test'; IPAddress = '192.0.2.10' }; Field = 'ipv4addr'; Expected = '192.0.2.10' }
            @{ Type = 'AAAA'; Parameters = @{ Name = 'host.example.test'; IPAddress = '2001:db8::10' }; Field = 'ipv6addr'; Expected = '2001:db8::10' }
            @{ Type = 'CNAME'; Parameters = @{ Name = 'alias.example.test'; CanonicalName = 'host.example.test' }; Field = 'canonical'; Expected = 'host.example.test' }
            @{ Type = 'TXT'; Parameters = @{ Name = 'txt.example.test'; Text = 'Verification=AbC123' }; Field = 'text'; Expected = 'Verification=AbC123' }
        ) {
            param($Type, $Parameters, $Field, $Expected)

            Add-InfoBloxDNSRecord -Type $Type @Parameters

            $script:requestMethod | Should -Be 'POST'
            $script:requestUri | Should -Be "record:$($Type.ToLowerInvariant())"
            $script:requestBody[$Field] | Should -BeExactly $Expected
            Should -Invoke Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'creates HOST records with the correct address family collection' -TestCases @(
            @{ Address = '192.0.2.10'; Collection = 'ipv4addrs'; Field = 'ipv4addr' }
            @{ Address = '2001:db8::10'; Collection = 'ipv6addrs'; Field = 'ipv6addr' }
        ) {
            param($Address, $Collection, $Field)

            Add-InfoBloxDNSRecord -Type HOST -Name 'host.example.test' -IPAddress $Address

            $script:requestBody[$Collection][0][$Field] | Should -Be $Address
            Should -Invoke Invoke-InfobloxQuery -Times 1 -Exactly
        }

        It 'creates PTR records from IPv4, IPv6, or an explicit name' -TestCases @(
            @{ Parameters = @{ IPAddress = '192.0.2.10' }; Field = 'ipv4addr'; Expected = '192.0.2.10' }
            @{ Parameters = @{ IPAddress = '2001:db8::10' }; Field = 'ipv6addr'; Expected = '2001:db8::10' }
            @{ Parameters = @{ Name = '10.2.0.192.in-addr.arpa' }; Field = 'name'; Expected = '10.2.0.192.in-addr.arpa' }
        ) {
            param($Parameters, $Field, $Expected)

            Add-InfoBloxDNSRecord -Type PTR -PtrName 'host.example.test' @Parameters

            $script:requestBody.ptrdname | Should -Be 'host.example.test'
            $script:requestBody[$Field] | Should -Be $Expected
        }

        It 'creates MX records with preference' {
            Add-InfoBloxDNSRecord -Type MX -Name 'example.test' -MailExchanger 'mail.example.test' -Preference 10

            $script:requestBody.mail_exchanger | Should -Be 'mail.example.test'
            $script:requestBody.preference | Should -Be 10
        }

        It 'creates NS records with structured glue addresses' {
            Add-InfoBloxDNSRecord -Type NS -Name 'example.test' -NameServer 'ns1.example.test' -Address '192.0.2.53', '2001:db8::53'

            $script:requestBody.nameserver | Should -Be 'ns1.example.test'
            $script:requestBody.addresses.Count | Should -Be 2
            $script:requestBody.addresses[0].address | Should -Be '192.0.2.53'
        }

        It 'creates an arbitrary WAPI record type through Properties' {
            Add-InfoBloxDNSRecord -Type SRV -Properties @{
                name = '_service._tcp.example.test'
                target = 'host.example.test'
                port = 443
                priority = 10
                weight = 5
            }

            $script:requestUri | Should -Be 'record:srv'
            $script:requestBody.target | Should -Be 'host.example.test'
            $script:requestBody.port | Should -Be 443
        }

        It 'normalizes legacy LBDN to the DTCLBDN WAPI endpoint' {
            Add-InfoBloxDNSRecord -Type LBDN -Properties @{ name = 'service.example.test' }

            $script:requestUri | Should -Be 'record:dtclbdn'
        }

        It 'supports nested WAPI record type names through Properties' {
            Add-InfoBloxDNSRecord -Type 'RPZ:CNAME' -Properties @{ name = 'blocked.example.test'; canonical = 'replacement.example.test' }

            $script:requestUri | Should -Be 'record:rpz:cname'
        }

        It 'rejects invalid typed input before invoking WAPI' {
            $previousPreference = $ErrorActionPreference
            try {
                $ErrorActionPreference = 'Stop'
                { Add-InfoBloxDNSRecord -Type A -Name 'host.example.test' -IPAddress '2001:db8::10' } | Should -Throw '*valid IPv4 address*'
            } finally {
                $ErrorActionPreference = $previousPreference
            }

            Should -Invoke Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'does not invoke WAPI under WhatIf' {
            Add-InfoBloxDNSRecord -Type CNAME -Name 'alias.example.test' -CanonicalName 'host.example.test' -WhatIf

            Should -Invoke Invoke-InfobloxQuery -Times 0 -Exactly
        }
    }
}
