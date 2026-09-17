---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Connect-Infoblox
## SYNOPSIS
Configures a connection to an Infoblox WAPI endpoint.

## SYNTAX
### Credential
```powershell
Connect-Infoblox -Server <string> -Credential <pscredential> [-ApiVersion <string>] [-EnableTLS12] [-AllowSelfSignedCerts] [-SkipInitialConnection] [-TimeoutSec <int>] [-ReturnObject] [<CommonParameters>]
```

### UserName
```powershell
Connect-Infoblox -Server <string> -Username <string> -EncryptedPassword <string> [-ApiVersion <string>] [-EnableTLS12] [-AllowSelfSignedCerts] [-SkipInitialConnection] [-TimeoutSec <int>] [-ReturnObject] [<CommonParameters>]
```

## DESCRIPTION
Stores the server, authentication, API version, web session, and request timeout used by PowerInfoblox commands.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Connect-Infoblox -Server 'grid.example.com' -Credential $Credential
```


### EXAMPLE 2
```powershell
PS > Connect-Infoblox -Server 'grid.example.com' -Credential $Credential -TimeoutSec 3600
```


## PARAMETERS

### -AllowSelfSignedCerts
Allows self-signed server certificates.

```yaml
Type: SwitchParameter
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiVersion
The WAPI version used to build the base URI.

```yaml
Type: String
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: False
Position: named
Default value: 2.11
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
The credential used to authenticate to Infoblox.

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableTLS12
Enables TLS 1.2 for the current PowerShell process.

```yaml
Type: SwitchParameter
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EncryptedPassword
A string created from a secure string for the specified user name.

```yaml
Type: String
Parameter Sets: UserName
Aliases: SecurePassword
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnObject
Returns the stored connection configuration.

```yaml
Type: SwitchParameter
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Server
The Infoblox server name or IP address.

```yaml
Type: String
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipInitialConnection
Skips the initial schema request that verifies the connection.

```yaml
Type: SwitchParameter
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutSec
The request timeout in seconds. The default is 600 seconds.

```yaml
Type: Int32
Parameter Sets: Credential, UserName
Aliases: None
Possible values:

Required: False
Position: named
Default value: 600
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
The user name used with an encrypted password.

```yaml
Type: String
Parameter Sets: UserName
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None
