import Cocoa
import ApplicationServices
import Carbon

class SonyZoomMuteApp: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var isEnabled = true

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar item
        setupMenuBar()

        // Request accessibility permissions
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if !accessibilityEnabled {
            print("⚠️  Accessibility permissions required. Please enable in System Preferences.")
            showAlert(title: "Permissions Required",
                     message: "Please grant Accessibility permissions in System Preferences > Privacy & Security > Accessibility")
        }

        // Set up media key monitoring
        setupMediaKeyMonitoring()

        print("✅ Sony WH1000XM5 → Zoom Mute is running")
        print("🎧 Listening for pause key from Sony headset...")
    }

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.title = "🎧"
            button.toolTip = "Sony WH1000XM5 Zoom Mute"
        }

        let menu = NSMenu()

        let enabledItem = NSMenuItem(title: "Enabled", action: #selector(toggleEnabled), keyEquivalent: "")
        enabledItem.state = isEnabled ? .on : .off
        menu.addItem(enabledItem)

        menu.addItem(NSMenuItem.separator())

        let statusItem = NSMenuItem(title: "Status: Listening for pause key", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)

        menu.addItem(NSMenuItem.separator())

        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        self.statusItem?.menu = menu
    }

    @objc func toggleEnabled(_ sender: NSMenuItem) {
        isEnabled.toggle()
        sender.state = isEnabled ? .on : .off
        print(isEnabled ? "✅ Enabled" : "⏸️  Disabled")
    }

    func setupMediaKeyMonitoring() {
        let eventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue) | (1 << NX_SYSDEFINED)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                let mySelf = Unmanaged<SonyZoomMuteApp>.fromOpaque(refcon!).takeUnretainedValue()
                return mySelf.handleMediaKeyEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            print("❌ Failed to create event tap")
            return
        }

        self.eventTap = eventTap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
    }

    func handleMediaKeyEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // Check if app is enabled
        guard isEnabled else {
            return Unmanaged.passRetained(event)
        }

        // Only process system defined events (media keys)
        if type == CGEventType(rawValue: UInt32(NX_SYSDEFINED))! {
            let nsEvent = NSEvent(cgEvent: event)

            if let data1 = nsEvent?.data1,
               let data2 = nsEvent?.data2 {

                let keyCode = Int32((data1 & 0xFFFF0000) >> 16)
                let keyFlags = (data1 & 0x0000FFFF)
                let keyPressed = ((keyFlags & 0xFF00) >> 8) == 0xA

                // NX_KEYTYPE_PLAY = 16 (Play/Pause key)
                if keyCode == 16 && keyPressed {
                    print("⏸️  Pause key detected from Sony headset")
                    handlePauseKeyPress()
                    // Consume the event so it doesn't pause media
                    return nil
                }
            }
        }

        return Unmanaged.passRetained(event)
    }

    func handlePauseKeyPress() {
        if isZoomRunning() {
            print("🔍 Zoom is running, toggling mute...")
            toggleZoomMute()
        } else {
            print("ℹ️  Zoom is not running, ignoring pause key")
        }
    }

    func isZoomRunning() -> Bool {
        let workspace = NSWorkspace.shared
        let runningApps = workspace.runningApplications

        return runningApps.contains { app in
            app.bundleIdentifier == "us.zoom.xos" ||
            app.localizedName?.lowercased().contains("zoom") == true
        }
    }

    func toggleZoomMute() {
        let script = """
        tell application "System Events"
            tell application process "zoom.us"
                if exists menu bar item "Meeting" of menu bar 1 then
                    click menu item "Mute audio" of menu 1 of menu bar item "Meeting" of menu bar 1
                    return "Muted"
                else
                    return "Not in meeting"
                end if
            end tell
        end tell
        """

        // Alternative: Use keyboard shortcut (Cmd+Shift+A is Zoom's default mute shortcut)
        let source = CGEventSource(stateID: .combinedSessionState)

        // Cmd key down
        let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: true)
        cmdDown?.flags = .maskCommand

        // Shift key down
        let shiftDown = CGEvent(keyboardEventSource: source, virtualKey: 0x38, keyDown: true)
        shiftDown?.flags = [.maskCommand, .maskShift]

        // 'A' key down
        let aDown = CGEvent(keyboardEventSource: source, virtualKey: 0x00, keyDown: true)
        aDown?.flags = [.maskCommand, .maskShift]

        // 'A' key up
        let aUp = CGEvent(keyboardEventSource: source, virtualKey: 0x00, keyDown: false)
        aUp?.flags = [.maskCommand, .maskShift]

        // Shift key up
        let shiftUp = CGEvent(keyboardEventSource: source, virtualKey: 0x38, keyDown: false)
        shiftUp?.flags = .maskCommand

        // Cmd key up
        let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: 0x37, keyDown: false)

        // Post events
        let loc = CGEventTapLocation.cghidEventTap
        cmdDown?.post(tap: loc)
        shiftDown?.post(tap: loc)
        aDown?.post(tap: loc)
        aUp?.post(tap: loc)
        shiftUp?.post(tap: loc)
        cmdUp?.post(tap: loc)

        print("🔇 Sent Zoom mute toggle (Cmd+Shift+A)")

        // Visual feedback
        DispatchQueue.main.async {
            if let button = self.statusItem?.button {
                let originalTitle = button.title
                button.title = "🔇"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    button.title = originalTitle
                }
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}

// Main entry point
let app = NSApplication.shared
let delegate = SonyZoomMuteApp()
app.delegate = delegate
app.run()
