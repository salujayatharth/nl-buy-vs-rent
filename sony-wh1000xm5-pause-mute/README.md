# Sony WH1000XM5 → Zoom Mute

A macOS menu bar application that automatically mutes/unmutes your Zoom microphone when you press the pause button on your Sony WH1000XM5 headphones.

## Features

- 🎧 **Detects Sony Headset Pause Key**: Listens for the pause/play button press on your Sony WH1000XM5 headphones
- 🔇 **Auto Zoom Mute**: Automatically toggles Zoom mute when Zoom is running
- 📊 **Menu Bar Integration**: Runs quietly in the menu bar
- ⚡ **Lightweight**: Minimal resource usage, Swift-based native app
- 🔒 **Privacy**: All processing happens locally, no network requests

## How It Works

1. The app monitors system-wide media key events
2. When it detects a pause key press from your Sony headphones
3. It checks if Zoom is currently running
4. If Zoom is active, it sends `Cmd+Shift+A` (Zoom's mute shortcut)
5. Your mic is toggled mute/unmute!

## Requirements

- macOS 12.0 (Monterey) or later
- Sony WH1000XM5 headphones (or any headset that sends media pause key)
- Zoom installed
- Xcode Command Line Tools (for building)

## Installation

### Option 1: Build from Source

```bash
# Navigate to the project directory
cd sony-wh1000xm5-pause-mute

# Build the application
swift build -c release

# Run the app
./.build/release/SonyZoomMute
```

### Option 2: Build Script

```bash
# Make the build script executable
chmod +x build.sh

# Build and run
./build.sh
```

## Setup

### 1. Grant Accessibility Permissions

When you first run the app, macOS will prompt you to grant Accessibility permissions:

1. Open **System Preferences** → **Privacy & Security** → **Accessibility**
2. Click the lock icon to make changes
3. Find `SonyZoomMute` in the list and enable it
4. If it's not there, click the `+` button and add the app

### 2. Start the App

Once permissions are granted:

```bash
./.build/release/SonyZoomMute
```

You should see a headphone icon (🎧) appear in your menu bar.

### 3. Test It

1. Open Zoom and join a meeting
2. Press the pause button on your Sony WH1000XM5 headphones
3. Your Zoom microphone should toggle mute!

## Usage

### Menu Bar Controls

Click the headphone icon (🎧) in the menu bar to:

- **Enable/Disable**: Toggle the app on/off
- **Status**: View current status
- **Quit**: Exit the application

### Running at Login (Optional)

To make the app start automatically when you log in:

1. Open **System Preferences** → **Users & Groups** → **Login Items**
2. Click the `+` button
3. Navigate to `.build/release/SonyZoomMute` and add it

Or use this command:

```bash
# Add to login items
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/path/to/SonyZoomMute", hidden:false}'
```

## Configuration

### Custom Zoom Shortcut

If you've changed Zoom's mute shortcut from the default `Cmd+Shift+A`:

1. Open `Sources/main.swift`
2. Find the `toggleZoomMute()` function
3. Update the virtual key codes to match your custom shortcut
4. Rebuild the app

### Other Headphones

While designed for Sony WH1000XM5, this should work with any Bluetooth headphones that send a standard pause/play media key.

## Troubleshooting

### App Not Detecting Pause Key

1. **Check Accessibility Permissions**: Ensure the app has Accessibility permissions
2. **Restart the App**: Quit and restart `SonyZoomMute`
3. **Check Console**: Run from terminal to see debug output

### Zoom Not Muting

1. **Verify Zoom is Running**: The app only works when Zoom is active
2. **Check Zoom Permissions**: Ensure Zoom has microphone permissions
3. **Test Manual Shortcut**: Try `Cmd+Shift+A` manually in Zoom
4. **Join a Meeting**: The mute toggle only works when in an active Zoom meeting

### Permission Issues

```bash
# Reset accessibility permissions (requires reboot)
sudo tccutil reset Accessibility

# Re-run the app and grant permissions again
```

## Development

### Project Structure

```
sony-wh1000xm5-pause-mute/
├── Package.swift           # Swift Package Manager configuration
├── Sources/
│   └── main.swift         # Main application code
├── README.md              # This file
└── build.sh               # Build script
```

### Building

```bash
# Debug build
swift build

# Release build
swift build -c release

# Clean build
swift package clean
```

### Debugging

Run with console output to see what's happening:

```bash
./.build/release/SonyZoomMute
```

You'll see messages like:
- `✅ Sony WH1000XM5 → Zoom Mute is running`
- `🎧 Listening for pause key from Sony headset...`
- `⏸️  Pause key detected from Sony headset`
- `🔍 Zoom is running, toggling mute...`
- `🔇 Sent Zoom mute toggle (Cmd+Shift+A)`

## Technical Details

### Media Key Detection

The app uses `CGEvent` tap to monitor system-wide keyboard events, specifically looking for `NX_SYSDEFINED` events with key code 16 (Play/Pause).

### Zoom Integration

Two methods are implemented:

1. **Keyboard Shortcut Simulation** (default): Sends `Cmd+Shift+A` key events
2. **AppleScript** (commented): Uses AppleScript to interact with Zoom's menu bar

The keyboard shortcut method is more reliable and doesn't require Zoom to be in focus.

### Permissions Required

- **Accessibility**: Required to monitor media keys and send keyboard events
- **Input Monitoring**: Automatically granted with Accessibility permissions

## Limitations

- Only works with Zoom (not Teams, Meet, etc.)
- Requires Accessibility permissions (security requirement)
- Media key must be from a headset that sends standard pause/play events
- Works best when Zoom is in an active meeting

## Future Enhancements

- [ ] Support for Microsoft Teams
- [ ] Support for Google Meet
- [ ] Configurable keyboard shortcuts
- [ ] Customizable headset button actions
- [ ] System notifications on mute/unmute
- [ ] Settings panel
- [ ] Auto-update functionality

## Contributing

Contributions are welcome! Feel free to:

- Report bugs
- Suggest features
- Submit pull requests

## License

MIT License - See LICENSE file for details

## Credits

Created for Sony WH1000XM5 users who want seamless Zoom muting.

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Run with debug output to see what's happening
3. Open an issue on GitHub with:
   - macOS version
   - Zoom version
   - Console output
   - Steps to reproduce

---

**Note**: This is a third-party tool not affiliated with Sony or Zoom.
