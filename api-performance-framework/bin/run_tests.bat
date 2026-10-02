@echo off
setlocal

set ROOT_DIR=%~dp0\..
set TEST_PLAN=%ROOT_DIR%\test-plans\User_API_Test.jmx
set PROPERTIES_FILE=%ROOT_DIR%\config\env-test.properties
set RESULT_DIR=%ROOT_DIR%\results\raw-data
set REPORT_DIR=%ROOT_DIR%\results\html-reports

if not exist "%RESULT_DIR%" mkdir "%RESULT_DIR%"
if not exist "%REPORT_DIR%" mkdir "%REPORT_DIR%"

set JMETER_BIN=%JMETER_HOME%\bin\jmeter.bat
if not exist "%JMETER_BIN%" (
    where jmeter >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo JMeter is not installed or JMETER_HOME is not set.
        echo Set JMETER_HOME or add jmeter to PATH.
        exit /b 1
    )
    for /f "delims=" %%i in ('where jmeter') do set JMETER_BIN=%%i
)

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value ^| findstr /r "^LocalDateTime="') do set TIMESTAMP=%%I
set TIMESTAMP=%TIMESTAMP:~0,8%_%TIMESTAMP:~8,6%

set OUTPUT_JTL=%RESULT_DIR%\results_%TIMESTAMP%.jtl
set REPORT_OUTPUT=%REPORT_DIR%\report_%TIMESTAMP%

"%JMETER_BIN%" ^
  -n ^
  -t "%TEST_PLAN%" ^
  -p "%PROPERTIES_FILE%" ^
  -l "%OUTPUT_JTL%" ^
  -e ^
  -o "%REPORT_OUTPUT%"

echo Test run complete.
echo JTL: %OUTPUT_JTL%
echo HTML Report: %REPORT_OUTPUT%
endlocal
