import SwiftUI
import IOKit.ps

@main
struct MenuBarPowerAdapterWattageApp: App {
    // Hooking the AppDelegate for the app
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // No main window needed for a menu bar app
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "...W"
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateWattage()
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }

    func updateWattage() {
        let wattage = self.getCurrentWattage()
        statusItem.isVisible = true
        statusItem.button?.title = wattage == 0 ? "BAT" : "\(wattage)W"
    }

    func getCurrentWattage() -> Int {
        if let adapterDetails = IOPSCopyExternalPowerAdapterDetails()?.takeRetainedValue() as? [String: Any],
           let watts = adapterDetails["Watts"] as? Int {
            return watts
        }
        return 0
    }
}
