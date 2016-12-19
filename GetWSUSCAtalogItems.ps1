param([string]$SiteServer, [string]$SiteCode ) 

# Set parameter defaults
$PassedParams =  (" -SiteServer "+$SiteServer+" -SiteCode "+$SiteCode+" -SQLServer "+$SQLServer+" -InstanceName "+$InstanceName)
If (!$SiteServer)   { $SiteServer   = "XSNW10S629K"                   }
If (!$SiteCode)     { $SiteCode     = "F01"                           }
If (!$InstanceName) { $InstanceName = "GetWSUSCatalogItems-PRE2PROD"    }


$Categories = @()
$Categories = get-WMIObject -ComputerName "$SiteServer"  -Namespace "root/SMS/Site_$SiteCode" -Query "SELECT * FROM SMS_UpdateCategoryInstance order by CategoryTypeName, LocalizedCategoryInstanceName "
$CAtegoriesLev1 = $Categories
Write-Host ("CatID`tParentCatID`tCatType`tCatName`tIsSubscribed`tLocaleID")
ForEach ($Category in $Categories) {
    If ( $Category.CategoryTypeName -eq "ProductFamily") {
        Write-Host ($Category.CategoryInstanceID.ToString()+"`t"+$Category.ParentCategoryInstanceID.ToString()+"`t"+$Category.CategoryTypeName+"`t"+$Category.LocalizedCategoryInstanceName+"`t"+$Category.IsSubscribed.ToString()+"`t"+$Category.LocalizedPropertyLocaleID.ToString())
        ForEach ($CategoryLev1 in $CategoriesLev1 ) {
            If ($CategoryLev1.parentCategoryInstanceID -eq $Category.CategoryInstanceID) {
                    Write-Host ($CategoryLev1.CategoryInstanceID.ToString()+"`t"+$CategoryLev1.ParentCategoryInstanceID.ToString()+"`t"+$CategoryLev1.CategoryTypeName+"`t"+$CategoryLev1.LocalizedCategoryInstanceName+"`t"+$CategoryLev1.IsSubscribed.ToString()+"`t"+$CategoryLev1.LocalizedPropertyLocaleID.ToString())
            }
        }
    }
}