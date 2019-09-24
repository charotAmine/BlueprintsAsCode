param(
    [string]$subscriptionId = $env:SUBSCRIPTIONID,
    [string]$mgId = $env:MGID,
    [string]$blueprintPath = $env:BLUEPRINTPATH,
    [string]$blueprintName = $env:BLUEPRINTNAME,
    [string]$spnId = $env:SPNID,
    [string]$spnPass = $env:SPNPASS,
    [string]$tenantId = $env:TENANTID,
    [string]$version = $env:VERSION
)

write-output "Subscription : $subscriptionId"
$securePass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $spnId, $securePass
Login-AzAccount -Credential $credential -ServicePrincipal -TenantId $tenantId

$createdBlueprint = Get-AzBlueprint -ManagementGroupId $mgId -Name $blueprintName -errorAction SilentlyContinue

if($createdBlueprint)
{
    Publish-AzBlueprint -Blueprint $createdBlueprint -Version $version
}else
{
    throw "Could not get Blueprint"
    exit 1
}