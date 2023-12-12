@echo off

if [%~1]==[] goto :noversion

set version=%1
set nugetFile=Selenium.WebDriver.MSEdgeDriver.nuspec

mkdir .\download\%version%
echo  Downloading %version%
curl https://msedgedriver.azureedge.net/%version%/edgedriver_win32.zip -o .\download\%version%\edgedriver_win32.zip
curl https://msedgedriver.azureedge.net/%version%/edgedriver_win64.zip -o .\download\%version%\edgedriver_win64.zip
curl https://msedgedriver.azureedge.net/%version%/edgedriver_mac64.zip -o .\download\%version%\edgedriver_mac64.zip
curl https://msedgedriver.azureedge.net/%version%/edgedriver_linux64.zip -o .\download\%version%\edgedriver_linux64.zip
PowerShell -Command "Expand-Archive -Path .\download\%version%\edgedriver_win32.zip -DestinationPath .\download\%version%\edgedriver_win32"
PowerShell -Command "Expand-Archive -Path .\download\%version%\edgedriver_win64.zip -DestinationPath .\download\%version%\edgedriver_win64"
PowerShell -Command "Expand-Archive -Path .\download\%version%\edgedriver_mac64.zip -DestinationPath .\download\%version%\edgedriver_mac64"
PowerShell -Command "Expand-Archive -Path .\download\%version%\edgedriver_linux64.zip -DestinationPath .\download\%version%\edgedriver_linux64"

if [%~2]==[] PowerShell -Command "(Get-Content -path Selenium.WebDriver.MSEdgeDriver.template.nuspec -Raw) -replace '_version_','%version%'" > %nugetFile%
if [%~2]==[pre] PowerShell -Command "(Get-Content -path Selenium.WebDriver.MSEdgeDriver.template-pre.nuspec -Raw) -replace '_version_','%version%'" > %nugetFile%
if [%~2]==[beta] PowerShell -Command "(Get-Content -path Selenium.WebDriver.MSEdgeDriver.template-beta.nuspec -Raw) -replace '_version_','%version%'" > %nugetFile%
if [%~2]==[dev] PowerShell -Command "(Get-Content -path Selenium.WebDriver.MSEdgeDriver.template-dev.nuspec -Raw) -replace '_version_','%version%'" > %nugetFile%

nuget pack %nugetFile% -OutputDirectory .\dist

echo Removing temp files ...
del /F /Q /S download\%version%
rmdir /S /Q download\%version%
del %nugetFile%
echo Done
echo to publish run:
if [%~2]==[] echo nuget push -Source nuget.org -ApiKey %NUGETPUSHAPIKEY% .\dist\Selenium.WebDriver.MSEdgeDriver.%version%.nupkg
if [%~2]==[pre] echo nuget push -Source nuget.org -ApiKey %NUGETPUSHAPIKEY% .\dist\Selenium.WebDriver.MSEdgeDriver.%version%-pre.nupkg
if [%~2]==[beta] echo nuget push -Source nuget.org -ApiKey %NUGETPUSHAPIKEY% .\dist\Selenium.WebDriver.MSEdgeDriver.%version%-beta.nupkg
if [%~2]==[dev] echo nuget push -Source nuget.org -ApiKey %NUGETPUSHAPIKEY% .\dist\Selenium.WebDriver.MSEdgeDriver.%version%-dev.nupkg
goto :finish

:noversion
echo .
echo .
echo missing version parameter
echo usage: BuildPackage.bat VERSION [pre]
echo Example
echo BuildPackage.bat 81.12.654
echo or
echo BuildPackage.bat 81.12.654 pre   ----- this generates a nuget package with a pre release version for testing.
echo BuildPackage.bat 81.12.654 beta  ----- this generates a nuget package with a beta release version for testing.
echo BuildPackage.bat 81.12.654 dev   ----- this generates a nuget package with a dev release version for testing.
echo .
echo .
echo to get your system's MsEdge version:
echo powershell.exe (Get-Item '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"').VersionInfo
:finish
