#!/bin/bash

# Meme Troller - Quick Start Script

echo "================================"
echo "Meme Troller - Deployment Script"
echo "================================"
echo ""

# --- Set the correct Docker Compose command (V2 preferred) ---
COMPOSE_CMD=""
if command -v docker compose &> /dev/null; then
    # Docker Compose V2 (preferred: docker compose)
    COMPOSE_CMD="docker compose"
elif command -v docker-compose &> /dev/null; then
    # Docker Compose V1 (fallback: docker-compose)
    COMPOSE_CMD="docker-compose"
else
    echo "❌ Docker Compose (v1 or v2) is not installed. Please install it first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check if Docker is installed (standard Docker CLI is a prerequisite for both V1 and V2)
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo "Running deployment using command: $COMPOSE_CMD"
echo ""

# Create necessary directories
echo "Creating directories..."
mkdir -p static/uploads instance
echo "✅ Directories created"
echo ""

# Build and start the application
echo "Building and starting the application..."
# Use the determined COMPOSE_CMD variable
$COMPOSE_CMD --build up -d

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
    echo "    The first user becomes the admin automatically."
    echo ""
    echo "To view logs:"
    echo "  $COMPOSE_CMD logs -f"
    echo ""
    echo "To stop the application:"
    echo "  $COMPOSE_CMD down"
    echo ""
else
    echo ""
    echo "❌ Failed to start the application"
    echo "Check the logs with: $COMPOSE_CMD logs"
    exit 1
fi
