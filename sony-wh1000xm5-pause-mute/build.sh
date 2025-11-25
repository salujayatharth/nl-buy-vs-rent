#!/bin/bash

# Sony WH1000XM5 → Zoom Mute Build Script

set -e

echo "🔨 Building Sony WH1000XM5 → Zoom Mute..."

# Build the application
swift build -c release

echo "✅ Build complete!"
echo ""
echo "To run the app:"
echo "  ./.build/release/SonyZoomMute"
echo ""
echo "⚠️  Remember to grant Accessibility permissions in:"
echo "  System Preferences → Privacy & Security → Accessibility"
echo ""

# Ask if user wants to run now
read -p "Run the app now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "🚀 Starting app..."
    ./.build/release/SonyZoomMute
fi
