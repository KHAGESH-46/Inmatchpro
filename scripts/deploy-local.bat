@echo off
REM Local Docker Deployment Script for InMatch Pro (Windows)
setlocal enabledelayedexpansion

echo 🚀 Starting InMatch Pro Local Deployment...

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker is not running. Please start Docker and try again.
    exit /b 1
)

REM Check if docker-compose is available
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ docker-compose is not installed. Please install it and try again.
    exit /b 1
)

REM Create environment files if they don't exist
if not exist "backend\.env" (
    echo 📝 Creating backend environment file...
    copy "backend\.env.example" "backend\.env"
    echo ⚠️  Please update backend\.env with your configuration
)

if not exist "frontend\.env" (
    echo 📝 Creating frontend environment file...
    copy "frontend\.env.example" "frontend\.env"
    echo ⚠️  Please update frontend\.env with your configuration
)

REM Build and start services
echo 🔨 Building Docker images...
docker-compose build

echo 🚀 Starting services...
docker-compose up -d

REM Wait for services to be healthy
echo ⏳ Waiting for services to be ready...
timeout /t 30 /nobreak >nul

REM Check if services are running
docker-compose ps | findstr "Up" >nul
if errorlevel 1 (
    echo ❌ Services failed to start. Check logs with: docker-compose logs
    exit /b 1
) else (
    echo ✅ Services are running!
    echo.
    echo 🌐 Frontend: http://localhost
    echo 🔧 Backend API: http://localhost:8000
    echo 📚 API Documentation: http://localhost:8000/docs
    echo.
    echo To stop services: docker-compose down
    echo To view logs: docker-compose logs -f
)
