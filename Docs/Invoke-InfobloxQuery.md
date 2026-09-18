---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Invoke-InfobloxQuery
## SYNOPSIS
Sends a request to an Infoblox WAPI endpoint.

## SYNTAX
### __AllParameterSets
```powershell
Invoke-InfobloxQuery [-BaseUri] <string> [-RelativeUri] <string> [[-Credential] <pscredential>] [[-WebSession] <WebRequestSession>] [[-QueryParameter] <IDictionary>] [[-Method] <string>] [[-Body] <IDictionary>] [[-TimeoutSec] <int>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Builds an Infoblox WAPI URI, sends the request, and returns the deserialized response.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Invoke-InfobloxQuery -BaseUri 'https://grid.example.com/wapi/v2.13.8' -RelativeUri 'network' -Credential $Credential
```


### EXAMPLE 2
```powershell
PS > Invoke-InfobloxQuery -BaseUri 'https://grid.example.com/wapi/v2.13.8' -RelativeUri 'network' -Credential $Credential -TimeoutSec 30
```


## PARAMETERS

### -BaseUri
The WAPI base URI.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
The request body, serialized as JSON.

```yaml
Type: IDictionary
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
The credential used to authenticate to Infoblox.

```yaml
Type: PSCredential
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The HTTP method. The default is GET.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 5
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryParameter
Query parameters appended to the request URI.

```yaml
Type: IDictionary
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelativeUri
The object path or URI relative to the WAPI base URI.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutSec
The request timeout in seconds. The default is 600 seconds.

```yaml
Type: Int32
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 7
Default value: 600
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebSession
The web request session used for cookie-based authentication.

```yaml
Type: WebRequestSession
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 3
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
