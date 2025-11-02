#!/bin/bash

# Meme Troller - Quick Start Script

echo "================================"
echo "Meme Troller - Deployment Script"
echo "================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Create necessary directories
echo "Creating directories..."
mkdir -p static/uploads instance
echo "✅ Directories created"
echo ""

# Build and start the application
echo "Building and starting the application..."
docker-compose up -d --build

if [ $? -eq 0 ]; then
    echo ""
    echo "================================"
    echo "✅ Meme Troller is now running!"
    echo "================================"
    echo ""
    echo "Access the application at:"
    echo "  🌐 http://localhost:5000"
    echo "  🌐 http://$(hostname -I | awk '{print $1}'):5000"
    echo ""
    echo "⚠️  IMPORTANT: Register the first user immediately!"
    echo "   The first user becomes the admin automatically."
    echo ""
    echo "To view logs:"
    echo "  docker-compose logs -f"
    echo ""
    echo "To stop the application:"
    echo "  docker-compose down"
    echo ""
else
    echo ""
    echo "❌ Failed to start the application"
    echo "Check the logs with: docker-compose logs"
    exit 1
fi
