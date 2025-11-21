@echo on
setlocal enabledelayedexpansion

REM --- Ensure required env vars are present ---
if "%PREFIX%"=="" (
  echo [build-desktop.bat] PREFIX is empty
  exit /b 1
)

REM --- Define source and destination paths ---
set "DOTSRC=%SRC_DIR%\dotnet"
set "DOTNET_ROOT=%PREFIX%\dotnet"

REM --- Verify source ---
if not exist "%DOTSRC%\shared\Microsoft.WindowsDesktop.App" (
  echo [build-desktop.bat] Source not found: "%DOTSRC%\shared\Microsoft.WindowsDesktop.App"
  dir "%DOTSRC%\shared"
  exit /b 1
)

REM --- Copy WindowsDesktop shared framework ---
mkdir "%DOTNET_ROOT%\shared\Microsoft.WindowsDesktop.App" 2>nul
xcopy /e /i /y "%DOTSRC%\shared\Microsoft.WindowsDesktop.App" "%DOTNET_ROOT%\shared\Microsoft.WindowsDesktop.App\" >nul

REM --- Sanity check ---
if not exist "%DOTNET_ROOT%\shared\Microsoft.WindowsDesktop.App" exit /b 1

exit /b 0
