import SwiftUI
import TuistBarToolUI
import TuistBarToolKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

@main
struct TuistBarToolApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {

        TuistMenuBar()

        WindowGroup {
            LogViewer()
        }.handlesExternalEvents(matching: ["LogViewer"])
    }
}
