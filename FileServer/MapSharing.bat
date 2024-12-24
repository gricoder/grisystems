@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

set "user=%USERNAME%"
set "logFile=%TEMP%\MapSharing_%time:~0,2%%time:~3,2%.log"
set "configfile=\\acme\netlogon\mapconfig\%user%.txt"

echo Script Started: %date% %time% >> "%logFile%"

if exist "%configfile%" (
    echo "%user% Config File Exist" >> "%logFile%"
) else (
    echo "%user% Config File Doesn't Exist"  >> "%logFile%"
	exit
)

set "counter=0"

for /f "delims=" %%a in (%configfile%) do (
    set /a counter+=1
    set "dep!counter!=%%a"
)

:: dep1
echo dep1: "!dep1!" >> "%logFile%"
net use Y: /delete >> "%logFile%"
net use Y: "!dep1!" /persistent:yes >> "%logFile%"
:: dep2
echo dep2: "!dep2!" >> "%logFile%"
net use Z: /delete >> "%logFile%"
net use Z: "!dep2!" /persistent:yes >> "%logFile%"

echo Script Finished: %date% %time% >> "%logFile%"

::endlocal
exit /b
