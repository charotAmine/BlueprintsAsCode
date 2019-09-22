param(
    [string]$subscriptionId,
    [string]$blueprintPath,
    [string]$blueprintName
)

Import-AzBlueprintWithArtifact -Name $blueprintName -SubscriptionId $subscriptionId -InputPath $blueprintPath