@echo off
 
@rem Check administrative permissions using net session command.
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Successfully checked administrative permissions.
) else (
    echo Run this script with administrative permissions.
    exit /b 1
)

setlocal EnableDelayedExpansion

@rem Create directory where data will be stored
@rem If you change this directory remember to set same path at .env file at JENKINS_CONFIGURATION_DATA_DIR
if not exist "c:\jenkins-demo\jenkins_configuration" (
  mkdir "c:\jenkins-demo\jenkins_configuration"
  if "!errorlevel!" EQU "0" (
    echo Successfully created folder "c:\jenkins-demo\jenkins_configuration".
  ) else (
    echo Error while creating folder "c:\jenkins-demo\jenkins_configuration".
    exit /b %errorlevel%
  )
)

@rem Create directory where data will be stored
@rem If you change this directory remember to set same path at .env file at DOCKERSOCK_DATA_DIR
if not exist "c:\jenkins-demo\docker.sock" (
  mkdir "c:\jenkins-demo\docker.sock"
  if "!errorlevel!" EQU "0" (
    echo Successfully created folder "c:\jenkins-demo\docker.sock".
  ) else (
    echo Error while creating folder "c:\jenkins-demo\docker.sock".
    exit /b %errorlevel%
  )
)

setlocal DisableDelayedExpansion

@rem Check if Docker desktop is running
docker ps 2>&1 | find /I /C "error" > NUL
if %errorlevel% EQU 0 (
    ECHO IMPORTANT: Run DOCKER DESKTOP before you start this script!
    ECHO IMPORTANT: I wait 30 seconds for DOCKER DESKTOP to launch, then continue.
    timeout 30
)

echo Running docker compose files.

docker-compose --env-file .env -f jenkins-docker-compose.yaml up

echo Done!
