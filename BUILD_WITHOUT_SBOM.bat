@echo off
set DOCKER_BUILDKIT=0
set BUILDKIT_PROGRESS=plain

echo Building without SBOM...
docker-compose build --progress plain
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo Starting services...
docker-compose up -d
if errorlevel 1 (
    echo Failed to start containers!
    pause
    exit /b 1
)

echo Done!
docker ps -a
