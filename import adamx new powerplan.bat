@echo off
:: Get the directory where the batch file is located
set SCRIPT_DIR=%~dp0

:: Set the "theplans" folder name
set PLANS_FOLDER=%SCRIPT_DIR%theplans

:: Set the power plan file name
set POWER_PLAN_FILE=adamxupdated.pow

:: Combine the directory path, "theplans" folder, and power plan file name
set POWER_PLAN_PATH=%PLANS_FOLDER%\%POWER_PLAN_FILE%

:: Check if the power plan file exists
if not exist "%POWER_PLAN_PATH%" (
    echo ERROR: The power plan file does not exist in the "theplans" folder.
    exit /b
)

:: Ask the user if they want to import and set the power plan
echo Do you want to import and set "%POWER_PLAN_FILE%" as the current power plan? (Y/N)
set /p USER_CONFIRM=

:: If user doesn't confirm, exit the script
if /i not "%USER_CONFIRM%"=="Y" (
    echo Operation canceled.
    exit /b
)

:: Import the custom power plan
echo Importing the custom power plan...
powercfg -import "%POWER_PLAN_PATH%"

:: Debug: Display all power plans to see the output
echo ---- DEBUG: Power Plan List ----
powercfg -list
echo ------------------------------

:: Extract the GUID of the imported power plan from the powercfg output
for /f "tokens=2 delims=:" %%i in ('powercfg -list ^| findstr /i "adamxupdated"') do (
    set PLAN_GUID=%%i
)

:: Ensure we only have the GUID part (remove any unwanted characters or strings)
set PLAN_GUID=%PLAN_GUID:~1,36%

:: Check if we got a GUID
if not defined PLAN_GUID (
    echo ERROR: Could not find the GUID of the imported power plan.
    exit /b
)

:: Activate the imported power plan
echo Setting the custom power plan as active...
powercfg -setactive %PLAN_GUID%

:: Confirm that the power plan was set successfully
echo Custom power plan "%POWER_PLAN_FILE%" has been imported and set as active.

:: Final confirmation
echo ------------------------------
echo The custom power plan was successfully applied!
exit /b
