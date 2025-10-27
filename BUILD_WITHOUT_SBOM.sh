#!/bin/bash
# Сборка без SBOM для избежания зависаний

export DOCKER_BUILDKIT=0

echo "Building without SBOM..."
docker-compose build

echo "Starting services..."
docker-compose up -d

echo "Done!"

