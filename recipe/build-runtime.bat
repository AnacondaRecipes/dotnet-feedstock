@echo on
setlocal enabledelayedexpansion

REM --- Ensure required env vars are present ---
REM conda-build provides PREFIX, SRC_DIR, RECIPE_DIR
if "%PREFIX%"=="" (
  echo [build-runtime.bat] PREFIX is empty
  exit /b 1
)

REM --- Define source and destination paths ---
set "DOTSRC=%SRC_DIR%\dotnet"
set "DOTNET_ROOT=%PREFIX%\dotnet"

REM --- Basic presence checks ---
if not exist "%DOTSRC%" (
  echo [build-runtime.bat] Source folder not found: "%DOTSRC%"
  exit /b 1
)
if not exist "%DOTSRC%\dotnet.exe" (
  echo [build-runtime.bat] dotnet.exe not found in "%DOTSRC%"
  dir "%DOTSRC%"
  REM We still continue; some distros may rely on shim runner only.
)

REM --- Create destination tree ---
mkdir "%DOTNET_ROOT%" 2>nul
mkdir "%DOTNET_ROOT%\shared" 2>nul
mkdir "%DOTNET_ROOT%\tools"  2>nul

REM --- Copy main dotnet launcher files ---
if exist "%DOTSRC%\dotnet.exe" copy /y "%DOTSRC%\dotnet.exe" "%DOTNET_ROOT%\"  >nul
if exist "%DOTSRC%\dotnet.dll" copy /y "%DOTSRC%\dotnet.dll" "%DOTNET_ROOT%\"  >nul

REM --- Copy .NET Core runtime (Microsoft.NETCore.App) ---
if exist "%DOTSRC%\shared\Microsoft.NETCore.App" (
  mkdir "%DOTNET_ROOT%\shared\Microsoft.NETCore.App" 2>nul
  xcopy /e /i /y "%DOTSRC%\shared\Microsoft.NETCore.App" "%DOTNET_ROOT%\shared\Microsoft.NETCore.App\" >nul
) else (
  echo [build-runtime.bat] WARNING: Missing shared\Microsoft.NETCore.App in source
)

REM --- Copy host binaries (for dotnet execution) ---
if exist "%DOTSRC%\host" (
  mkdir "%DOTNET_ROOT%\host" 2>nul
  xcopy /e /i /y "%DOTSRC%\host" "%DOTNET_ROOT%\host\" >nul
)

REM --- Install activate/deactivate hooks ---
mkdir "%PREFIX%\etc\conda\activate.d"   2>nul
mkdir "%PREFIX%\etc\conda\deactivate.d" 2>nul
if exist "%RECIPE_DIR%\activate.d"   copy /y "%RECIPE_DIR%\activate.d\*"   "%PREFIX%\etc\conda\activate.d\"   >nul
if exist "%RECIPE_DIR%\deactivate.d" copy /y "%RECIPE_DIR%\deactivate.d\*" "%PREFIX%\etc\conda\deactivate.d\" >nul

REM --- Sanity check ---
if exist "%DOTNET_ROOT%\dotnet.exe" (
  "%DOTNET_ROOT%\dotnet.exe" --list-runtimes
)

exit /b %errorlevel%
