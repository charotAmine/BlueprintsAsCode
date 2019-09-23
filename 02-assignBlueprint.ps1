param(
    [string]$subscriptionId = $env:SUBSCRIPTIONID,
    [string]$assignmentFile = $env:ASSIGNMENTFILE,
    [string]$blueprintName = $env:BLUEPRINTNAME,
    [string]$spnId = $env:SPNID,
    [string]$spnPass = $env:SPNPASS,
    [string]$tenantId = $env:TENANTID,
    [string]$version = $env:VERSION
)

Install-Module -Name Az.Blueprint -AllowClobber -Force

if (!(Get-Module -ListAvailable -Name Az.Blueprint)) {
    throw "Module does not exist"
    exit 1 
} 

$securePass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $spnId, $securePass
Login-AzAccount -Credential $credential -ServicePrincipal -TenantId $tenantId

$createdBlueprint = Get-AzBlueprint -SubscriptionId $subscriptionId -Name $blueprintName -LatestPublished -errorAction SilentlyContinue

if($createdBlueprint)
{
        New-AzBlueprintAssignment -Name "assigned-$blueprintName" -Blueprint $createdBlueprint -AssignmentFile $assignmentFile -SubscriptionId $subscriptionId 
}else
{
    throw "Could not get Blueprint"
    exit 1
}