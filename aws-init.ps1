<powershell>
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

cinst nodejs.install -y

choco install notepadplusplus.install -y

(new-object net.webclient).DownloadFile('https://github.com/httptoolkit/httptoolkit-desktop/releases/download/v1.2.1/HttpToolkit-installer-1.2.1.exe','c:\HttpToolkit-installer-1.2.1.exe')

(new-object net.webclient).DownloadFile('https://github.com/xrzes/scottbotv1-releases/releases/download/v2.6.17/scottbotv1-Setup-2.6.17.exe','c:\scottbotv1-Setup-2.6.17.exe')

</powershell>
