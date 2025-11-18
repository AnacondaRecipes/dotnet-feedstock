@echo on
setlocal enabledelayedexpansion

REM --- Ensure required env vars are present ---
if "%PREFIX%"=="" (
  echo [build-sdk.bat] PREFIX is empty
  exit /b 1
)

REM --- Define source and destination paths ---
set "DOTSRC=%SRC_DIR%\dotnet"
set "DOTNET_ROOT=%PREFIX%\dotnet"

REM --- Verify source ---
if not exist "%DOTSRC%" (
  echo [build-sdk.bat] Source folder not found: "%DOTSRC%"
  exit /b 1
)

REM --- Copy SDK, packs, templates, and workloads if present ---
for %%D in (sdk packs templates workloads sdk-manifests) do (
  if exist "%DOTSRC%\%%D" (
    mkdir "%DOTNET_ROOT%\%%D" 2>nul
    xcopy /e /i /y "%DOTSRC%\%%D" "%DOTNET_ROOT%\%%D\" >nul
  )
)

REM --- Install activate/deactivate hooks (optional, kept for parity) ---
mkdir "%PREFIX%\etc\conda\activate.d"   2>nul
mkdir "%PREFIX%\etc\conda\deactivate.d" 2>nul
if exist "%RECIPE_DIR%\activate.d"   copy /y "%RECIPE_DIR%\activate.d\*"   "%PREFIX%\etc\conda\activate.d\"   >nul
if exist "%RECIPE_DIR%\deactivate.d" copy /y "%RECIPE_DIR%\deactivate.d\*" "%PREFIX%\etc\conda\deactivate.d\" >nul

REM --- Sanity checks (match your tests) ---
if not exist "%DOTNET_ROOT%\packs" exit /b 1
if not exist "%DOTNET_ROOT%\sdk" exit /b 1
if not exist "%DOTNET_ROOT%\templates" exit /b 1

REM --- Optional: verify dotnet works ---
if exist "%DOTNET_ROOT%\dotnet.exe" (
  "%DOTNET_ROOT%\dotnet.exe" --version
)

exit /b %errorlevel%
