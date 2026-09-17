Describe 'DNS record retrieval' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13.8' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = $Script:InfobloxConfiguration.BaseUri
            $script:requestUri = $null
            $script:query = $null
            Mock Get-FieldsFromSchema -MockWith { $null }
            Mock Invoke-InfobloxQuery -MockWith {
                $script:requestUri = $RelativeUri
                $script:query = $QueryParameter
                [pscustomobject]@{ name = 'record.example.test'; _ref = 'record/reference' }
            }
            Mock Select-Properties -MockWith { @('name', '_ref') }
        }

        AfterAll {
            $Script:InfobloxConfiguration = $null
            $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:BaseUri')
        }

        It 'normalizes LBDN to the DTCLBDN endpoint' {
            Get-InfobloxDNSRecord -Type LBDN | Out-Null

            $script:requestUri | Should -Be 'record:dtclbdn'
        }

        It 'allows a future WAPI record type without a static ValidateSet' {
            Get-InfobloxDNSRecord -Type CAA | Out-Null

            $script:requestUri | Should -Be 'record:caa'
            $script:query.ContainsKey('_return_fields') | Should -BeFalse
        }

        It 'allows nested WAPI record type names' {
            Get-InfobloxDNSRecord -Type 'RPZ:CNAME' | Out-Null

            $script:requestUri | Should -Be 'record:rpz:cname'
        }

        It 'gets one record by exact object reference and infers its type' {
            $referenceID = 'record:aaaa/opaque:host.example.test/default'

            Get-InfobloxDNSRecord -ReferenceID $referenceID -ReturnFields name,ipv6addr,view | Out-Null

            $script:requestUri | Should -Be $referenceID
            $script:query.ContainsKey('_max_results') | Should -BeFalse
            $script:query._return_fields | Should -Be 'ipv6addr,name,view'
        }

        It 'rejects a non-record object reference' {
            { Get-InfobloxDNSRecord -ReferenceID 'network/opaque:192.0.2.0/24/default' } | Should -Throw '*is not a DNS record WAPI object reference*'

            Should -Invoke Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'preserves explicit return fields and maximum results' {
            Get-InfobloxDNSRecord -Type MX -ReturnFields preference,name,preference -MaxResults 25 | Out-Null

            $script:query._return_fields | Should -Be 'name,preference'
            $script:query._max_results | Should -Be 25
            Should -Invoke Get-FieldsFromSchema -Times 0 -Exactly
        }

        It 'builds partial-match filters consistently' {
            Get-InfobloxDNSRecord -Type TXT -Name 'Verify' -Zone 'Example.Test' -View 'Internal' -PartialMatch | Out-Null

            $script:query['name~'] | Should -Be 'verify'
            $script:query['zone~'] | Should -Be 'example.test'
            $script:query['view~'] | Should -Be 'internal'
        }

        It 'rejects unsafe type tokens before invoking WAPI' {
            { Get-InfobloxDNSRecord -Type '../grid' } | Should -Throw '*not a valid WAPI record type*'

            Should -Invoke Invoke-InfobloxQuery -Times 0 -Exactly
        }

        It 'supports explicit fields and limits for allrecords' {
            Get-InfobloxDNSRecordAll -ReturnFields type,name,type -MaxResults 50 | Out-Null

            $script:requestUri | Should -Be 'allrecords'
            $script:query._return_fields | Should -Be 'name,type'
            $script:query._max_results | Should -Be 50
            Should -Invoke Get-FieldsFromSchema -Times 0 -Exactly
        }
    }
}
