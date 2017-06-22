function Get-ProjectRepoUrl {
    param (
        [string] $account,
        [string] $projectName
    )
     
    $projectRepoUrl = 'https://' + $account + '.visualstudio.com/defaultcollection/' + $projectName;
    return $projectRepoUrl;
}

function Get-BasicAuthorizationHeaders {
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

function Get-UriGetCallResult {
    param (
        [uri] $uri,
        [hashtable] $headers
    )
    $result = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get;
    return $result;
}

function Get-QueryString {
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

function Get-OperationTypeSubUrl {
    param (
        [string] $operationType
    )

    $subUrl = "";
    switch ($operationType)
    {                
        "Build" { $subUrl = "/_apis/build/builds"; }
        Default { $subUrl = ""; } 
    }
    return $subUrl;
}

function Get-ResultsUri {
    param (
        [string] $account,
        [string] $projectName,
        [string] $operationType,
        [hashtable] $queryParameters,
        [string] $extraUrl
    )

    $projectRepoUrl = Get-ProjectRepoUrl -account $account -projectName $projectName;
    
    $subUrl = Get-OperationTypeSubUrl -operationType $operationType;
    $queryString = Get-QueryString -queryParameters $queryParameters;    
    [uri] $uri =  ("{0}{1}{2}{3}" -f $projectRepoUrl, $subUrl, $extraUrl, $queryString);

    return uri; 
}

$altCredUsername = "";
$altCredPassword = "";
$headers = Get-BasicAuthorizationHeaders -altCredUsername $altCredUsername -altCredPassword $altCredPassword;

$account = "";
$projectName = "";
$operationType = "";
$queryParameters = @{};
$extraUrl = "";
$uri = Get-ResultsUri -account $account -projectName $projectName -operationType $operationType -queryParameters $queryParameters -extraUrl $extraUrl;

$results = Get-UriGetCallResult -uri $uri -headers $headers;
