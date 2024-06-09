# 登入 Azure
#az login

# 獲取 ACR 登入服務的名稱
$registryName = "kTCDockRegistry"
$resourceGroupName = "KTCFE.DevOps"
az acr show --name $registryName --resource-group $resourceGroupName --query loginServer --output tsv


# 獲取所有的 repository
$repositories = az acr repository list --name $registryName --output tsv

foreach ($repository in $repositories)
{
    if ($repository -notlike "base*")
    {
        # 獲取每個 repository 的所有 manifest（包含 tag 和最後修改時間）
        $tags = az acr repository show-tags --name $registryName --repository $repository --detail --output json | ConvertFrom-Json

        # 排序 manifest 並保留最新的三個
        $latestTags = $tags | Sort-Object { $_.lastUpdateTime } -Descending | Select-Object -First 2

        foreach ($tag in $tags)
        {
            if ($tag.name -notin $latestTags.name)
            {
                az acr repository delete --name $registryName --image "${repository}:$($tag.name)" --yes
            }
        }
    }
}