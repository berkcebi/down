//
//  AppDelegate.swift
//  Down
//
//  Created by K. Berk Cebi on 5/23/18.
//  Copyright © 2018 Zeplin, Inc. All rights reserved.
//

import AppKit

@NSApplicationMain
final class AppDelegate: NSObject {
    
    // MARK: Properties
    
    private let windowController = WindowController()
}

// MARK: NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        windowController.showWindow(nil)
        windowController.window?.center()
    }
}
