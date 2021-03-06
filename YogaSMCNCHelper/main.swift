//
//  AppDelegate.swift
//  YogaSMCNCHelper
//
//  Created by Zhen on 10/12/20.
//  Copyright © 2020 Zhen. All rights reserved.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainBundleID = Bundle.main.bundleIdentifier!.replacingOccurrences(of: "Helper", with: "")
        let bundlePath = Bundle.main.bundlePath as NSString

        guard NSRunningApplication.runningApplications(withBundleIdentifier: mainBundleID).isEmpty else {
            return NSApp.terminate(self)
        }

        let pathComponents = bundlePath.pathComponents
        let path = NSString.path(withComponents: Array(pathComponents[0 ..< (pathComponents.count - 4)]))

        if !NSWorkspace.shared.launchApplication(path) {
            let alert = NSAlert()
            alert.messageText = "Failed to open \(path)"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        NSApp.terminate(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {}
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
