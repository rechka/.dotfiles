<script>
bcdedit.exe -set TESTSIGNING ON
</script>
<powershell>

Set-TimeZone -Id "Eastern Standard Time" -PassThru

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

cinst nodejs.install -y --no-progress
cinst notepadplusplus.install -y --no-progress
cinst winrar -y --no-progress
cinst gpu-z -y --no-progress
cinst selenium-chrome-driver --pre -y --no-progress
cinst selenium -y --no-progress
cinst firefox -y --no-progress

(new-object net.webclient).DownloadFile('https://github.com/httptoolkit/httptoolkit-desktop/releases/download/v1.4.1/HttpToolkit-installer-1.4.1.exe','c:\HttpToolkit.exe')
Start-Process -Wait -FilePath "C:\HttpToolkit.exe" -ArgumentList "/S" -PassThru

(new-object net.webclient).DownloadFile('https://us.download.nvidia.com/tesla/462.31/462.31-data-center-tesla-desktop-win10-64bit-dch-international.exe','c:\nvidia.exe')
Start-Process -Wait -FilePath "C:\nvidia.exe" -ArgumentList "-s" -PassThru

function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force -ErrorAction Continue
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
function Enable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 1 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 1 -Force
    Stop-Process -Name Explorer -Force -ErrorAction Continue
    Write-Host "IE Enhanced Security Configuration (ESC) has been enabled." -ForegroundColor Green
}
function Disable-UserAccessControl {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 -Force
    Write-Host "User Access Control (UAC) has been disabled." -ForegroundColor Green    
}
Disable-UserAccessControl
Disable-InternetExplorerESC




$Shell = New-Object -ComObject("WScript.Shell")
$Favorite = $Shell.CreateShortcut($env:USERPROFILE + "\Desktop\Win ISO.url")
$Favorite.TargetPath = "https://www.microsoft.com/en-ca/software-download/windows10ISO";
$Favorite.Save()

Restart-Computer
</powershell>
