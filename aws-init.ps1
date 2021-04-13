<powershell>

Set-TimeZone -Id "Eastern Standard Time" -PassThru

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

cinst nodejs.install -y --no-progress

choco install notepadplusplus.install -y --no-progress

(new-object net.webclient).DownloadFile('https://github.com/httptoolkit/httptoolkit-desktop/releases/download/v1.2.1/HttpToolkit-installer-1.2.1.exe','c:\HttpToolkit-installer-1.2.1.exe')

Start-Process -Wait -FilePath "C:\HttpToolkit-installer-1.2.1.exe" -ArgumentList "/S" -PassThru

(new-object net.webclient).DownloadFile('https://github.com/xrzes/scottbotv1-releases/releases/download/v2.6.29/scottbotv1-Setup-2.6.29.exe','c:\scottbotv1-Setup.exe')
Start-Process -Wait -FilePath "C:\scottbotv1-Setup.exe" -ArgumentList "/S" -PassThru

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


function DoCV {
	notepad++ C:\ProgramData\Amazon\EC2-Windows\Launch\Log\UserdataExecution.log
}

Set-Alias cv DoCV

cinst rclone -y --no-progress

choco install selenium-chrome-driver --pre -y --no-progress
choco install selenium -y --no-progress
choco install ungoogled-chromium --version=84.0.4147.1351 -y --no-progress

</powershell>
