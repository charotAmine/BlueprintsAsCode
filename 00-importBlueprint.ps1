param(
    [string]$subscriptionId,
    [string]$blueprintPath,
    [string]$blueprintName,
    [string]$spnId,
    [string]$spnPass,
    [string]$tenantId
)

Install-Module -Name Az.Blueprint -AllowClobber -Force
if (!(Get-Module "Az.Blueprint")) {
    throw "Module Az.Blueprint was not downloaded"
    exit 1
}

$securePass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $spnId, $securePass
Login-AzAccount -Credential $credential -ServicePrincipal -TenantId $tenantId

Import-AzBlueprintWithArtifact -Name $blueprintName -SubscriptionId $subscriptionId -InputPath $blueprintPath -Force