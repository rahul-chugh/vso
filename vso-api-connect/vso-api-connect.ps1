Get-ProjectRepoUrl {
    param (
        [string] $account,
        [string] $projectName
    )
     
    $projectRepoUrl = 'https://' + $account + '.visualstudio.com/defaultcollection/' + $projectName;
    return $projectRepoUrl;
}

Get-BasicAuthorizationHeaders {
    param (
        [string] $altCredUsername,
        [string] $altCredPassword
    )

    $basicAuth = ("{0}:{1}" -f $altCredUsername,$altCredPassword);
    $basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth); 
    $basicAuth = [System.Convert]::ToBase64String($basicAuth); 
    $headers = @{Authorization=("Basic {0}" -f $basicAuth)};
    return $headers;
}

Get-UriGetCallResult {
    param (
        [uri] $uri,
        $headers
    )
    $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get;
    return $result;
}

Get-QueryString {
    param(
        $queryParameters
    )
    
    $queryString = "";
    $prependText = "?";
    $queryParameters.Keys | % { 
        $queryString += $prependText + "$_=" + $queryParameters.Item($_);
        $prependText = "&";
    }
    return $queryString;
}

Get-BuildUri {
    param (
        [string] $projectRepoUrl,
        $queryParameters
    )
    $queryString = Get-QueryString -queryParameters $queryParameters;
    $buildSubUrl = "/_apis/build/builds" + $queryString;
}
