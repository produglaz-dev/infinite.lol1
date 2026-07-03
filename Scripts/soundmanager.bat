@echo off
setlocal enabledelayedexpansion

set SOURCE=%~dp0sounds
set TARGET=C:\Program Files (x86)\Steam\steamapps\common\Animal Company\sounds

if not exist "%TARGET%" mkdir "%TARGET%"

echo [Soundboard Sync] Watching for files...

:loop
for %%F in ("%SOURCE%\*.mp3") do (
    if not exist "%TARGET%\%%~nF.wav" (
        echo Converting and adding: %%~nF.mp3 -^> %%~nF.wav
        
        :: Create a temporary native Windows audio converter script
        echo Set stream = CreateObject("SAPI.SpFileStream") > "%temp%\mp3towav.vbs"
        echo stream.Format.Type = 18 >> "%temp%\mp3towav.vbs"
        echo stream.Open "%TARGET%\%%~nF.wav", 3, False >> "%temp%\mp3towav.vbs"
        echo Set voice = CreateObject("SAPI.SpVoice") >> "%temp%\mp3towav.vbs"
        echo Set voice.AudioOutputStream = stream >> "%temp%\mp3towav.vbs"
        echo Set input = CreateObject("SAPI.SpSharedFromFileStream") >> "%temp%\mp3towav.vbs"
        echo input.Open "%%F", 0, False >> "%temp%\mp3towav.vbs"
        echo stream.Write input.Read(0, input.Size) >> "%temp%\mp3towav.vbs"
        echo stream.Close >> "%temp%\mp3towav.vbs"
        echo input.Close >> "%temp%\mp3towav.vbs"
        
        :: Run the native Windows audio encoder hidden in the background
        cscript //nologo "%temp%\mp3towav.vbs" >nul 2>&1
        del "%temp%\mp3towav.vbs" >nul 2>&1
        
        if not exist "%TARGET%\%%~nF.wav" (
            echo [Error] Windows refused to decode %%~nF.mp3 automatically.
        )
    )
)

:: Keep your original logic for standard WAV files
for %%F in ("%SOURCE%\*.wav") do (
    if not exist "%TARGET%\%%~nxF" (
        copy "%%F" "%TARGET%\%%~nxF" >nul
        echo Added %%~nxF
    )
)

timeout /t 2 >nul