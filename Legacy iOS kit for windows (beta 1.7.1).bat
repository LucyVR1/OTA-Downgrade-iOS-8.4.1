@echo off
:menu
cls
echo ================================================
echo     OTA DOWNGRADER FOR IOS (Beta 1.6.1)
echo [!] This Beta only includes iOS 8.4.1 restore!
echo ================================================
echo  1. Download Jailbreak IPAs
echo  2. Start Restore (iOS 8.4.1)
echo  3. Exit
echo ================================================
echo.

set "user_choice="
set /p user_choice="Enter your selection (1-3): "

if "%user_choice%"=="1" goto download_ipas
if "%user_choice%"=="2" goto ios_8.4.1_restore
if "%user_choice%"=="3" goto exit_program
goto menu

:download_ipas
cls
echo =======================================================
echo  Select Your Jailbreak IPAs (Check Your iOS version!)
echo =======================================================
echo.
echo  [!] IMPORTANT: Check Your iOS version first, then select the ipa you need.
echo.
echo  Choose how you want to proceed:
echo  [1] Socket (iOS 10 to 10.3.3 or 10.3.4) [5,5C]
echo  [2] Carbon (iOS 8 to 9.3.6) [4S,5,5C]
echo.
set "restore_choice="
set /p restore_choice="Enter choice (1-2): "

if "%restore_choice%"=="1" goto download_socket
if "%restore_choice%"=="2" goto download_carbon
goto download_ipas

:download_socket
cls
echo ====================================================
echo  Downloading Socket IPA...
echo ====================================================
echo.

:: Direct link to the official Socket IPA release
curl -L -o socket.ipa "https://github.com/staturnzz/socket/releases/latest/download/socket.ipa"

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Failed to download socket.ipa. Please check your internet connection.
    pause
    goto menu
)

echo.
echo [+] Download Complete! socket.ipa saved to current directory.
pause
goto menu

:download_carbon
cls
echo ====================================================
echo  Carbon Jailbreak Instructions
echo ====================================================
echo.
echo  Carbon is a WebKit jailbreak and does NOT use an IPA file.
echo.
echo  To jailbreak using Carbon:
echo  1. Connect your target iOS device to Wi-Fi.
echo  2. Open Safari on the device (iOS 8.0 - 9.3.6).
echo  3. Navigate to: http://carbon.sep.lol
echo  4. Tap "Run" on the web page to execute the jailbreak.
echo.
pause
goto menu

:ios_8.4.1_restore
cls
echo ====================================================
echo    Restoring to iOS 8.4.1 (OTA Downgrade Method)
echo ====================================================
echo.
echo  [!] IMPORTANT: Make sure you have already applied the 
echo      iOS 6.1.3 plist spoof to your iPhone 5 first!
echo.
echo  Choose how you want to proceed:
echo  [1] Follow instructions to update on-device (Easiest)
echo  [2] Trigger an immediate over-the-air check via SSH (NOT checked, so it might not work)
echo  [3] Jailbreak instructions
echo  [4] Restore to iOS 8.4.1 (Do Option 1 or 2 before doing this!)
echo.
set "restore_choice="
set /p restore_choice="Enter choice (1-3): "

if "%restore_choice%"=="1" goto ota_instructions
if "%restore_choice%"=="2" goto ota_ssh_trigger
if "%restore_choice%"=="3" goto jailbreak_instructions
if "%restore_choice%"=="4" goto Restoring_iOS_8.4.1
goto ios_8.4.1_restore

:ota_instructions
cls
echo ====================================================
echo  On-Device Update Instructions
echo ====================================================
echo  1. Your iPhone 5 should have just rebooted.
echo  2. Go to Settings -> General -> Software Update.
echo  3. You should see iOS 8.4.1 available.
echo  4. Tap "Download and Install".
echo.
echo  Note: If it says your software is up to date (iOS 6.1.3),
echo  make sure your Wi-Fi is connected and try turning 
echo  Wi-Fi off and back on again.
echo.
pause
goto menu

:ota_ssh_trigger
cls
echo ====================================================
echo        Triggering OTA Update via SSH
echo ====================================================
set "IP_ADDRESS="
set /p IP_ADDRESS="[-] Enter your iPhone's IP Address: "
if "%IP_ADDRESS%"=="" goto ota_ssh_trigger

echo.
echo [*] Sending command to force check for updates...
echo [*] Enter your root password when prompted (Default is 'alpine').
echo.
ssh root@%IP_ADDRESS% "killall -9 com.apple.assetsd mobileassetd && echo [+] Command sent. Now open Settings -^> General -^> Software Update on your phone."
pause
goto menu

:jailbreak_instructions
cls
echo ====================================================
echo              Jailbreak Instructions
echo ====================================================
echo.
echo 1. Download a Socket.ipa or Restore to 10.3.3/10.3.4 with a jailbreak (Legacy iOS Kit for MacOS/Linux)
echo 2. After Installing Cydia, download OpenSSH or if you wanna do it manually just download Filza
echo.
echo ====================================================
echo        MANUAL INSTALL to download OTA 8.4.1
echo ====================================================
echo. 
echo 3. Go to /System/Library/CoreServices/SystemVersion.plist in Filza
echo 4. Then change the Version To 6.1.3 (10B329)
echo 5. Restart The iPhone
echo 6. Open Settings -> General -> Software Update -> Install iOS 8.

:Restoring_iOS_8.4.1
cls
echo ========================================================================
echo                         Restoring to iOS 8.4.1...
echo ========================================================================
echo [!] This is still in beta and hasn't been tested, so it might not work.

:: Check if the file exists in the current directory
if not exist "iOS 8.4.1.ipsw" (
    echo [ERROR] Could not find "iOS 8.4.1.ipsw" in the current folder.
    echo Please make sure the file is named correctly and placed in this folder.
    pause
    goto :eof
)

echo [SUCCESS] Found "iOS 8.4.1.ipsw". Proceeding...

:FirstQuestion
choice /c YN /m "ARE YOU SURE you want to restore to iOS 8.4.1?"
if errorlevel 2 goto :Cancel
if errorlevel 1 goto :SecondQuestion

:SecondQuestion
choice /c YN /m "Are you sure? This will erase all data on the device, AND this is still in beta"
if errorlevel 2 goto :Cancel
if errorlevel 1 goto :Proceed

:Proceed
echo.
echo ========================================================================
echo                     Starting idevicerestore Process
echo ========================================================================
echo [!] Ensure your device is connected in DFU or Recovery mode.
echo [!!] Do not disconnect your device during the restore process...
echo [!!!] You Need idevicerestore, or get the OTA update from itunes
echo.

:: Execute idevicerestore directly inside the CMD terminal
:: -e erases all data and flashes the specified IPSW
idevicerestore.exe -e "iOS 8.4.1.ipsw"

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Restore completed successfully!
) else (
    echo.
    echo [ERROR] Restore failed with error code %errorlevel%.
)
goto :End

:Cancel
echo Process canceled by user.

:End
pause

