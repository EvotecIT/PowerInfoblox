Describe 'DNS record removal' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $script:removedReferences = [System.Collections.Generic.List[string]]::new()
            $script:logMessages = [System.Collections.Generic.List[string]]::new()
            Mock Remove-InfobloxObject -MockWith {
                $script:removedReferences.Add($ReferenceID)
                $true
            }
            Mock Write-Color -MockWith {
                $script:logMessages.Add([string] $Text)
            }
        }

        It 'removes a record type that was not in the old static list' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'example.test'; _ref = 'record:mx/reference' }
            }

            Remove-InfobloxDnsRecord -Name 'example.test' -Type MX

            $script:removedReferences | Should -Be @('record:mx/reference')
        }

        It 'finds and removes an associated IPv6 PTR record' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return [pscustomobject]@{ name = $Name; ptrdname = 'host.example.test'; view = 'Internal'; _ref = 'record:ptr/reference' }
                }
                [pscustomobject]@{ name = $Name; ipv6addr = '2001:db8::1'; view = 'Internal'; _ref = 'record:aaaa/reference' }
            }

            Remove-InfobloxDnsRecord -Name 'host.example.test' -Type AAAA

            Should -Invoke Get-InfobloxDNSRecord -ParameterFilter {
                $Type -eq 'PTR' -and $Name -eq '1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa' -and $View -eq 'Internal'
            } -Times 1 -Exactly
            $script:removedReferences.Count | Should -Be 2
        }

        It 'does not reuse a previous PTR name when a later address is invalid' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return [pscustomobject]@{ name = $Name; ptrdname = 'good.example.test'; view = 'Internal'; _ref = 'record:ptr/reference' }
                }
                if ($Name -eq 'good.example.test') {
                    return [pscustomobject]@{ name = $Name; ipv4addr = '192.0.2.10'; view = 'Internal'; _ref = 'record:a/good' }
                }
                [pscustomobject]@{ name = $Name; ipv4addr = 'not-an-address'; view = 'Internal'; _ref = 'record:a/bad' }
            }

            Remove-InfobloxDnsRecord -Name 'good.example.test', 'bad.example.test' -Type A -WarningAction SilentlyContinue

            Should -Invoke Get-InfobloxDNSRecord -ParameterFilter { $Type -eq 'PTR' } -Times 1 -Exactly
            $script:removedReferences.Count | Should -Be 3
        }

        It 'skips automatic PTR cleanup when the source view is unknown' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'host.example.test'; ipv4addr = '192.0.2.10'; _ref = 'record:a/host' }
            }

            Remove-InfobloxDnsRecord -Name 'host.example.test' -Type A -WarningAction SilentlyContinue

            Should -Invoke Get-InfobloxDNSRecord -ParameterFilter { $Type -eq 'PTR' } -Times 0 -Exactly
            $script:removedReferences | Should -Be @('record:a/host')
        }

        It 'skips ambiguous name-based removal by default' {
            Mock Get-InfobloxDNSRecord -MockWith {
                @(
                    [pscustomobject]@{ name = $Name; mail_exchanger = 'mail1.example.test'; _ref = 'record:mx/one' }
                    [pscustomobject]@{ name = $Name; mail_exchanger = 'mail2.example.test'; _ref = 'record:mx/two' }
                )
            }

            Remove-InfobloxDnsRecord -Name 'example.test' -Type MX -WarningAction SilentlyContinue

            Should -Invoke Remove-InfobloxObject -Times 0 -Exactly
        }

        It 'removes an ambiguous record set only with explicit opt-in' {
            Mock Get-InfobloxDNSRecord -MockWith {
                @(
                    [pscustomobject]@{ name = $Name; mail_exchanger = 'mail1.example.test'; _ref = 'record:mx/one' }
                    [pscustomobject]@{ name = $Name; mail_exchanger = 'mail2.example.test'; _ref = 'record:mx/two' }
                )
            }

            Remove-InfobloxDnsRecord -Name 'example.test' -Type MX -View Internal -RemoveAllMatching

            $script:removedReferences | Should -Be @('record:mx/one', 'record:mx/two')
            Should -Invoke Get-InfobloxDNSRecord -ParameterFilter { $View -eq 'Internal' } -Times 1 -Exactly
        }

        It 'removes one exact object reference' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'example.test'; view = 'Internal'; _ref = $ReferenceID }
            }

            $referenceID = 'record:mx/opaque:example.test/Internal'
            Remove-InfobloxDnsRecord -ReferenceID $referenceID -Type MX

            $script:removedReferences | Should -Be @($referenceID)
            Should -Invoke Get-InfobloxDNSRecord -ParameterFilter { $ReferenceID -eq 'record:mx/opaque:example.test/Internal' } -Times 1 -Exactly
        }

        It 'refuses an exact lookup that returns a different object reference' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'other.example.test'; view = 'Internal'; _ref = 'record:mx/different-reference' }
            }

            {
                Remove-InfobloxDnsRecord -ReferenceID 'record:mx/requested-reference:example.test/Internal' -Type MX
            } | Should -Throw '*returned a different object reference*'

            Should -Invoke Remove-InfobloxObject -Times 0 -Exactly
        }

        It 'keeps a PTR that points to a different host' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return [pscustomobject]@{ name = $Name; ptrdname = 'current.example.test'; view = 'Internal'; _ref = 'record:ptr/current' }
                }
                [pscustomobject]@{ name = 'stale.example.test'; ipv4addr = '192.0.2.10'; view = 'Internal'; _ref = 'record:a/stale' }
            }

            Remove-InfobloxDnsRecord -Name 'stale.example.test' -Type A

            $script:removedReferences | Should -Be @('record:a/stale')
        }

        It 'keeps a PTR returned from a different view' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return [pscustomobject]@{ name = $Name; ptrdname = 'host.example.test'; view = 'External'; _ref = 'record:ptr/external' }
                }
                [pscustomobject]@{ name = 'host.example.test'; ipv4addr = '192.0.2.10'; view = 'Internal'; _ref = 'record:a/internal' }
            }

            Remove-InfobloxDnsRecord -Name 'host.example.test' -Type A

            $script:removedReferences | Should -Be @('record:a/internal')
        }

        It 'skips ambiguous associated PTR records by default' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return @(
                        [pscustomobject]@{ name = $Name; ptrdname = 'host.example.test'; view = 'Internal'; _ref = 'record:ptr/one' }
                        [pscustomobject]@{ name = $Name; ptrdname = 'host.example.test'; view = 'Internal'; _ref = 'record:ptr/two' }
                    )
                }
                [pscustomobject]@{ name = 'host.example.test'; ipv4addr = '192.0.2.10'; view = 'Internal'; _ref = 'record:a/host' }
            }

            Remove-InfobloxDnsRecord -Name 'host.example.test' -Type A -WarningAction SilentlyContinue

            $script:removedReferences | Should -Be @('record:a/host')
        }

        It 'keeps the associated PTR when forward deletion fails' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return [pscustomobject]@{ name = $Name; ptrdname = 'host.example.test'; view = 'Internal'; _ref = 'record:ptr/host' }
                }
                [pscustomobject]@{ name = 'host.example.test'; ipv4addr = '192.0.2.10'; view = 'Internal'; _ref = 'record:a/host' }
            }
            Mock Remove-InfobloxObject -ParameterFilter { $ReferenceID -eq 'record:a/host' } -MockWith { $false }

            Remove-InfobloxDnsRecord -Name 'host.example.test' -Type A -WarningAction SilentlyContinue

            Should -Invoke Remove-InfobloxObject -ParameterFilter { $ReferenceID -eq 'record:a/host' } -Times 1 -Exactly
            Should -Invoke Remove-InfobloxObject -ParameterFilter { $ReferenceID -eq 'record:ptr/host' } -Times 0 -Exactly
        }

        It 'blocks deletion of address children owned by a HOST record' {
            { Remove-InfobloxDnsRecord -Name 'host.example.test' -Type host_ipv4addr } | Should -Throw '*cannot be deleted directly*'

            Should -Invoke Remove-InfobloxObject -Times 0 -Exactly
        }

        It 'passes WhatIf through without removing the record' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = $Name; _ref = 'record:txt/reference' }
            }

            Remove-InfobloxDnsRecord -Name 'txt.example.test' -Type TXT -WhatIf

            Should -Invoke Remove-InfobloxObject -ParameterFilter { $WhatIf -eq $true } -Times 1 -Exactly
        }

        It 'logs successful forward and associated PTR deletion results' {
            Mock Get-InfobloxDNSRecord -MockWith {
                if ($Type -eq 'ptr') {
                    return [pscustomobject]@{ name = $Name; ptrdname = 'host.example.test'; view = 'Internal'; _ref = 'record:ptr/host' }
                }
                [pscustomobject]@{ name = 'host.example.test'; ipv4addr = '192.0.2.10'; view = 'Internal'; _ref = 'record:a/host' }
            }

            Remove-InfobloxDnsRecord -Name 'host.example.test' -Type A -LogPath 'removal.log'

            $script:logMessages | Should -Contain 'Removed host.example.test with type A'
            $script:logMessages | Should -Contain 'Removed 10.2.0.192.in-addr.arpa with type PTR'
        }

        It 'logs a failed deletion result when the API reports no success' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'example.test'; _ref = 'record:mx/example' }
            }
            Mock Remove-InfobloxObject -MockWith { $false }

            Remove-InfobloxDnsRecord -Name 'example.test' -Type MX -LogPath 'removal.log' -WarningAction SilentlyContinue

            $script:logMessages | Should -Contain 'Failed to remove example.test with type MX'
        }

        It 'logs the exception when deletion throws' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'example.test'; _ref = 'record:mx/example' }
            }
            Mock Remove-InfobloxObject -MockWith { throw 'synthetic delete failure' }

            Remove-InfobloxDnsRecord -Name 'example.test' -Type MX -LogPath 'removal.log' -WarningAction SilentlyContinue

            $script:logMessages | Should -Contain 'Failed to remove example.test with type MX, error: synthetic delete failure'
        }

        It 'logs WhatIf as a preview rather than a successful deletion' {
            Mock Get-InfobloxDNSRecord -MockWith {
                [pscustomobject]@{ name = 'txt.example.test'; _ref = 'record:txt/example' }
            }

            Remove-InfobloxDnsRecord -Name 'txt.example.test' -Type TXT -LogPath 'removal.log' -WhatIf

            $script:logMessages | Should -Contain 'WhatIf: Would remove txt.example.test with type TXT'
            $script:logMessages | Should -Not -Contain 'Removed txt.example.test with type TXT'
        }
    }
}

Describe 'Convert-IpAddressToPtrString' {
    InModuleScope PowerInfoblox {
        It 'converts IPv4 to in-addr.arpa' {
            Convert-IpAddressToPtrString -IPAddress '192.0.2.10' | Should -Be '10.2.0.192.in-addr.arpa'
        }

        It 'converts IPv6 to ip6.arpa' {
            Convert-IpAddressToPtrString -IPAddress '2001:db8::1' | Should -Be '1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa'
        }

        It 'rejects invalid input' {
            { Convert-IpAddressToPtrString -IPAddress 'not-an-address' } | Should -Throw '*not a valid IPv4 or IPv6 address*'
        }
    }
}
