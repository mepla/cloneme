#!/bin/bash

# Development script to manage backend and frontend services
# Reads configuration from config.json

CONFIG_FILE="config.json"
BACKEND_PORT=$(cat $CONFIG_FILE | grep -o '"backend": [0-9]*' | grep -o '[0-9]*')
FRONTEND_WEB_PORT=$(cat $CONFIG_FILE | grep -A2 '"web":' | grep -o '"web": [0-9]*' | grep -o '[0-9]*')

function kill_port() {
    local port=$1
    echo "Killing processes on port $port..."
    lsof -ti:$port | xargs kill -9 2>/dev/null || true
}

function start_backend() {
    echo "Starting backend on port $BACKEND_PORT..."
    kill_port $BACKEND_PORT
    cd backend && source venv/bin/activate && python3 -m uvicorn app.main:app --reload --port $BACKEND_PORT &
    echo "Backend started on http://localhost:$BACKEND_PORT"
}

function start_frontend_web() {
    echo "Starting frontend web on port $FRONTEND_WEB_PORT..."
    kill_port $FRONTEND_WEB_PORT
    cd frontend && flutter run -d web-server --web-port $FRONTEND_WEB_PORT &
    echo "Frontend web started on http://localhost:$FRONTEND_WEB_PORT"
}

function start_frontend_ios() {
    echo "Starting frontend iOS simulator..."
    flutter emulators --launch apple_ios_simulator
    sleep 5
    cd frontend && flutter run -d "iPhone 16 Plus" &
    echo "Frontend iOS simulator started"
}

function stop_all() {
    echo "Stopping all services..."
    kill_port $BACKEND_PORT
    kill_port $FRONTEND_WEB_PORT
    pkill -f "flutter run" 2>/dev/null || true
    echo "All services stopped"
}

case "$1" in
    "backend")
        start_backend
        ;;
    "frontend-web")
        start_frontend_web
        ;;
    "frontend-ios")
        start_frontend_ios
        ;;
    "all")
        start_backend
        sleep 2
        start_frontend_web
        sleep 2
        start_frontend_ios
        ;;
    "stop")
        stop_all
        ;;
    *)
        echo "Usage: $0 {backend|frontend-web|frontend-ios|all|stop}"
        echo ""
        echo "Configuration:"
        echo "  Backend port: $BACKEND_PORT"
        echo "  Frontend web port: $FRONTEND_WEB_PORT"
        echo "  Frontend iOS: iPhone 16 Plus simulator"
        exit 1
        ;;
esac