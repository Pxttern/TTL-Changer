@echo off
chcp 65001 > nul
mode con cols=65 lines=15
title [/] TTL CHANGER - Pxttern [\]

if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)

:MAIN
    CLS
    for /f "tokens=6" %%i in ('ping -n 1 127.0.0.1 ^| find "TTL"') do set ttl=%%i
    echo             ╔╦╗╔╦╗╦    ╔═╗╦ ╦╔═╗╔╗╔╔═╗╔═╗╦═╗
    echo              ║  ║ ║    ║  ╠═╣╠═╣║║║║ ╦║╣ ╠╦╝
    echo              ╩  ╩ ╩═╝  ╚═╝╩ ╩╩ ╩╝╚╝╚═╝╚═╝╩╚═
    echo.
    echo Ваш TTL: %ttl%
    echo.
    echo Выберите режим:
    echo 1 - 60 TTL (смена)
    echo 2 - 128 TTL (по умолчанию)
    echo.

    set /P "choice=Введите номер режима: "
    if "%choice%"=="1" goto ONE
    if "%choice%"=="2" goto TWO
    goto MAIN

:ONE
    netsh int ipv4 set glob defaultcurhoplimit=60 >NUL
    netsh int ipv6 set glob defaultcurhoplimit=60 >NUL
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 32 /f
    msg * "Вы поменяли свой TTL на 60!"
    exit /b

:TWO
    netsh int ipv4 set glob defaultcurhoplimit=128 >NUL
    netsh int ipv6 set glob defaultcurhoplimit=128 >NUL
    reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /f
    msg * "Вы поменяли свой TTL на 128!"
    exit /b
