#########################
# Autoinstall script using chocolatey https://gist.github.com/borgfriend/5727365
#########################
# Note: Net 4.0 must be installed prior to running this script

param(
    [string]$app_list_path
)

$current_path = $app_list_path

$items = Get-Content "$current_path\app_list.txt"
write-host $items.count total lines read from file

#################
# Create packages.config based on passed arguments
#################
$xml = '<?xml version="1.0" encoding="utf-8"?>'+ "`n" +'<packages>' + "`n"
foreach ($item in $items) {
  if(![string]::IsNullOrEmpty($item)) {
       if (!$item.StartsWith("#")) {
           $xml += "`t" +'<package id="' + $item + '"/>' + "`n"
       }
    } 
}
$xml += '</packages>'
 
#$file = ([system.environment]::getenvironmentvariable("userprofile") + "\packages.config")
New-Item -Force -ItemType directory -Path $current_path\tmp
$file = "$current_path\tmp\packages.config"

$xml | out-File $file

######
# Install packages with cinst
###### 
cinst $file -y
 
########
# Delete packages.config
Remove-Item $file
Remove-Item $current_path\tmp -Force -Recurse