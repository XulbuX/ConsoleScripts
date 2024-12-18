@echo OFF
setlocal enabledelayedexpansion
title Activate Windows

:: DETECT WINDOWS VERSION
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "10.0" ( set "WIN_VER=10" )
else if "%version%" == "11.0" ( set "WIN_VER=11") 
else (
    echo Unsupported Windows version.
    goto :EOF
)

:: DEFINE PRODUCT KEYS
set "KEYS[Enterprise]=NPPR9-FWDCX-D2C8J-H872K-2YT43,DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4,YYVX9-NTFWV-6MDM3-9PT4T-4M68B"
set "KEYS[Home]=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99,3KHY7-WNT83-DGQKR-F7HPR-844BM,7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"
set "KEYS[Education]=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2,2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
set "KEYS[Pro]=W269N-WFGWX-YVC9B-4J6C9-T83GX,MH37W-N47XK-V7XM9-C7227-GCQG9,NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"

:: DETECT WINDOWS EDITION
for /f "tokens=2 delims==" %%a in ('wmic os get caption /value') do set "EDITION=%%a"
set "EDITION=!EDITION:Microsoft Windows =!"
set "EDITION=!EDITION: =!"

echo Attempting to activate Windows !WIN_VER! !EDITION!...

:: TRY ACTIVATION
for %%k in (!KEYS[%EDITION%]!) do (
    cscript //nologo slmgr.vbs /ipk %%k >nul
    cscript //nologo slmgr.vbs /ato | find /i "successfully" >nul && (
        echo Activation successful.
        goto :EOF
    )
)

echo Activation failed. Please check your internet connection or try again later.

:EOF
pause
