#########################
# Autoinstall script using chocolatey https://gist.github.com/borgfriend/5727365
#########################
# Note: Net 4.0 must be installed prior to running this script

param(
    [string]$app_list_path
)

$current_path = Split-Path $MyInvocation.MyCommand.Path
$items = Get-Content "$app_list_path"

#################
# Create packages.config based on passed arguments
#################
$xml = '<?xml version="1.0" encoding="utf-8"?>'+ "`n" +'<packages>' + "`n"

$count_app_install = 0
$count_app_common = $items.count
foreach ($item in $items) {
	if(![string]::IsNullOrEmpty($item)) {
		if (!$item.StartsWith("#")) {
			$xml += "`t" +'<package id="' + $item + '"/>' + "`n"
			$count_app_install++
		}
	} 
}
$xml += '</packages>'

write-host installing applications [$count_app_install] from [$count_app_common]

#$file = ([system.environment]::getenvironmentvariable("userprofile") + "\packages.config")
New-Item -Force -ItemType directory -Path $current_path\tmp
$file = "$current_path\tmp\packages.config"

$xml | out-File $file

######
# Install packages with cinst
###### 
cinst $file -y
 
########
# Delete tmp files (packages.config)
Remove-Item $file
Remove-Item $current_path\tmp -Force -Recurse