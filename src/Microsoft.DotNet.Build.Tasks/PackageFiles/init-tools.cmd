@echo off
setlocal

set PROJECT_DIR=%~1
set PACKAGES_DIR=%~2
set NUGET_PATH=%~3

echo PROJECT_DIR=[%PROJECT_DIR%]
echo PACKAGES_DIR=[%PACKAGES_DIR%]
echo NUGET_PATH=[%NUGET_PATH%] 

if not exist "%PROJECT_DIR%" (
  echo ERROR: Cannot find project root path at [%PROJECT_DIR%]. Please pass in the source directory as the 1st parameter.
  exit /b 1
)

if not exist "%PACKAGES_DIR%" (
  echo ERROR: Cannot find packages path at [%PACKAGES_DIR%]. Please pass in the packages directory as the 2nd parameter.
  exit /b 1
)

if not exist "%NUGET_PATH%" (
  echo ERROR: Cannot find nuget at [%NUGET_PATH%]. Please pass in the nuget tool path as the 3rd parameter.
  exit /b 1
)


:: Eventually need to restore msbuild but for now we still depend on it existing alread and on the path

call msbuild "%~dp0InitializeTools.proj" /t:RestoreBuildTools /p:NuGetToolPath="%NUGET_PATH%" /p:PackagesDir="%PACKAGES_DIR%" /p:ProjectDir="%PROJECT_DIR%" /nologo /flp:v=diag;LogFile="%~dp0InitializeTools.log"

exit /b %ERRORLEVEL%