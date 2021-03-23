<powershell>
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

cinst nodejs.install -y

choco install notepadplusplus.install -y

(new-object net.webclient).DownloadFile('https://github.com/httptoolkit/httptoolkit-desktop/releases/download/v1.2.1/HttpToolkit-installer-1.2.1.exe','c:\HttpToolkit-installer-1.2.1.exe')

(new-object net.webclient).DownloadFile('https://github.com/xrzes/scottbotv1-releases/releases/download/v2.6.17/scottbotv1-Setup-2.6.17.exe','c:\scottbotv1-Setup-2.6.17.exe')

function Disable-ieESC

{
	$AdminKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}”
	$UserKey = “HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}”
	Set-ItemProperty -Path $AdminKey -Name “IsInstalled” -Value 0
	Set-ItemProperty -Path $UserKey -Name “IsInstalled” -Value 0
	Stop-Process -Name Explorer
	Write-Host “IE Enhanced Security Configuration (ESC) has been disabled.” -ForegroundColor Green
}

Disable-ieESC


</powershell>
