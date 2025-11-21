@echo on
setlocal enabledelayedexpansion

REM --- Ensure required env vars are present ---
if "%PREFIX%"=="" (
  echo [build-aspnetcore.bat] PREFIX is empty
  exit /b 1
)

REM --- Define source and destination paths ---
set "DOTSRC=%SRC_DIR%\dotnet"
set "DOTNET_ROOT=%PREFIX%\dotnet"

REM --- Verify source ---
if not exist "%DOTSRC%\shared\Microsoft.AspNetCore.App" (
  echo [build-aspnetcore.bat] Source not found: "%DOTSRC%\shared\Microsoft.AspNetCore.App"
  dir "%DOTSRC%\shared"
  exit /b 1
)

REM --- Copy ASP.NET Core shared framework ---
mkdir "%DOTNET_ROOT%\shared\Microsoft.AspNetCore.App" 2>nul
xcopy /e /i /y "%DOTSRC%\shared\Microsoft.AspNetCore.App" "%DOTNET_ROOT%\shared\Microsoft.AspNetCore.App\" >nul

REM --- Install activate/deactivate hooks (optional, kept for parity) ---
mkdir "%PREFIX%\etc\conda\activate.d"   2>nul
mkdir "%PREFIX%\etc\conda\deactivate.d" 2>nul
if exist "%RECIPE_DIR%\activate.d"   copy /y "%RECIPE_DIR%\activate.d\*"   "%PREFIX%\etc\conda\activate.d\"   >nul
if exist "%RECIPE_DIR%\deactivate.d" copy /y "%RECIPE_DIR%\deactivate.d\*" "%PREFIX%\etc\conda\deactivate.d\" >nul

REM --- Sanity check ---
if not exist "%DOTNET_ROOT%\shared\Microsoft.AspNetCore.App" exit /b 1

exit /b 0
