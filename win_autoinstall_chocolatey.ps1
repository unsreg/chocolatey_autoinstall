#########################
# Autoinstall script using chocolatey https://gist.github.com/borgfriend/5727365
#########################
# Note: Net 4.0 must be installed prior to running this script
#
#Modify this line to change packages
#$items = @(
#	"chocolateygui"
#	,"flashplayerplugin"
#	, "DotNet4.5",
#	, "vlc"
#	, "7zip.install") 
$items = Get-Content "app_list.txt"
write-host $data.count total lines read from file

#################
# Create packages.config based on passed arguments
#################
$xml = '<?xml version="1.0" encoding="utf-8"?>'+ "`n" +'<packages>' + "`n"
foreach ($item in $items) {
  if(![string]::IsNullOrEmpty($item)) {            
       $xml += "`t" +'<package id="' + $item + '"/>' + "`n"
    } 
}
$xml += '</packages>'
 
#$file = ([system.environment]::getenvironmentvariable("userprofile") + "\packages.config")
New-Item -Force -ItemType directory -Path $pwd\tmp
$file = "$pwd\tmp\packages.config"

$xml | out-File $file

######
# Install packages with cinst
###### 
cinst $file -y
 
########
# Delete packages.config
Remove-Item $file
Remove-Item $pwd\tmp -Force -Recurse