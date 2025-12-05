#!/bin/bash
# Script to configure the development environment variables and clean the project.
# This script should be "sourced" to apply the variables to the current terminal session.
# Example: source setup_dev_env.sh

echo "--- Configuring Development Environment & Cleaning Project ---"

# 1. Get the local IP address of the machine.
IP=$(hostname -I | awk '{print $1}')

if [ -z "$IP" ]; then
    echo "❌ Error: Could not find local IP address. Make sure you are connected to a network."
    return 1
fi

# 2. Export the environment variables for this terminal session.
export APP_ENV=dev
export FIRESTORE_EMULATOR_HOST=$IP

echo "✅ Environment configured for this session:"
echo "   - APP_ENV = $APP_ENV"
echo "   - FIRESTORE_EMULATOR_HOST = $FIRESTORE_EMULATOR_HOST"
echo ""

# 3. Clean the project to ensure a fresh build.
echo "🧹 Cleaning project..."
flutter clean
echo ""
echo "📦 Getting dependencies..."
flutter pub get
echo ""

echo "✅ Environment configured and project cleaned."
echo "🚀 You can now run 'flutter run' in this terminal."
echo "   This will be a clean build, so it may take a minute."