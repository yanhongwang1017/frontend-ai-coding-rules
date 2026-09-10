@echo off
rem ============================================================
rem  Copy .agents\ and AGENTS.md from this folder to target projects
rem  Put this .bat in the same folder as .agents\ and AGENTS.md
rem  First run: type target paths, separate multiple paths with ;
rem  They are saved to targets.txt; later just press Enter to reuse
rem ============================================================

setlocal enabledelayedexpansion
set "SRC=%~dp0"
set "LIST=%SRC%targets.txt"

rem ---- read saved targets from targets.txt (# lines are comments) ----
set "SAVED="
if exist "%LIST%" (
  for /f "usebackq eol=# delims=" %%L in ("%LIST%") do (
    if not "%%L"=="" set "SAVED=!SAVED!;%%L"
  )
)
if defined SAVED set "SAVED=!SAVED:~1!"

echo Source folder: %SRC%
if defined SAVED (
  echo Saved targets:
  echo    !SAVED!
  echo Press Enter to use them, or type new paths separated by ;
) else (
  echo Enter target project folders, separate multiple paths with ;
)
set "INPUT="
set /p "INPUT=Paths: "
echo.

if not "!INPUT!"=="" (
  set "USED=!INPUT!"
  set "NEW=1"
) else (
  set "USED=!SAVED!"
  set "NEW=0"
)

if "!USED!"=="" (
  echo No path entered. Nothing to do.
  echo.
  pause
  exit /b
)

rem drop spaces around semicolons, so "A ; B" becomes "A;B"
set "USED=!USED: ;=;!"
set "USED=!USED:; =;!"

rem typing new paths overwrites the saved list
if "!NEW!"=="1" type nul >"%LIST%"

:next
if "!USED!"=="" goto :done

set "T="
set "REST="
for /f "tokens=1* delims=; eol=|" %%A in ("!USED!") do (
  set "T=%%A"
  set "REST=%%B"
)
set "USED=!REST!"

if "!T!"=="" goto :next
if "!NEW!"=="1" >>"%LIST%" echo(!T!
call :sync "!T!"
goto :next

:done
echo.
if "!NEW!"=="1" echo Saved to targets.txt, press Enter next time.
echo All done.
pause
exit /b


:sync
set "T=%~1"
echo ==^> [%T%]

if not exist "%T%\" (
  echo    skip: target folder not found
  exit /b
)

if exist "%T%\.agents" rmdir /s /q "%T%\.agents"
xcopy "%SRC%.agents" "%T%\.agents" /E /I /Y /Q >nul
copy /y "%SRC%AGENTS.md" "%T%\AGENTS.md" >nul

echo    replaced .agents\ and AGENTS.md
exit /b
