@echo OFF
setlocal EnableDelayedExpansion
title Activate Windows

:: PRODUCT KEYS
set "KEYS[10][Enterprise]=NPPR9-FWDCX-D2C8J-H872K-2YT43|DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4|YYVX9-NTFWV-6MDM3-9PT4T-4M68B"
set "KEYS[10][Home]=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99|3KHY7-WNT83-DGQKR-F7HPR-844BM|7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"
set "KEYS[10][Education]=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2|2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
set "KEYS[10][Pro]=W269N-WFGWX-YVC9B-4J6C9-T83GX|MH37W-N47XK-V7XM9-C7227-GCQG9|NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"
set "KEYS[11][Enterprise]=NPPR9-FWDCX-D2C8J-H872K-2YT43|DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4|YYVX9-NTFWV-6MDM3-9PT4T-4M68B"
set "KEYS[11][Home]=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99|3KHY7-WNT83-DGQKR-F7HPR-844BM|7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"
set "KEYS[11][Education]=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2|2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
set "KEYS[11][Pro]=W269N-WFGWX-YVC9B-4J6C9-T83GX|MH37W-N47XK-V7XM9-C7227-GCQG9|NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"

:: KMS SERVERS
set "KMS=kms7.msguides.com|kms8.msguides.com|kms9.msguides.com"

:: DETECT WINDOWS VERSION & EDITION
for /f "tokens=2 delims==" %%a in ('wmic os get caption /value') do (
    for /f "tokens=3,4" %%b in ("%%a") do (
        set "VERSION=%%b"
        set "EDITION=%%c"
    )
)

echo.
echo 
echo Activating Microsoft Windows %VERSION% %EDITION% ...
echo.

:: ACTIVATION
set "keys=!KEYS[%EDITION%]!"
for %%k in ("%keys:|=" "%") do (
    echo Installing KMS client key %%~k ...
    cscript //nologo slmgr.vbs /ipk %%~k >nul
    echo Setting KMS machine address ...
    cscript //nologo slmgr.vbs /skms kms8.msguides.com >nul
    echo Activating ...
    cscript //nologo slmgr.vbs /ato | find /i "successfully" >nul && (
        echo Activation successful.
        goto :EOF
    )
)

echo Activation failed. Please check your internet connection or try again later.

:EOF
echo.
pause
