//
//  WindowController.swift
//  Down
//
//  Created by K. Berk Cebi on 5/23/18.
//  Copyright © 2018 Zeplin, Inc. All rights reserved.
//

import AppKit

final class WindowController: NSWindowController {
    
    // MARK: Properties
    
    private let viewController = ViewController()
    
    // MARK: Initializers
    
    required init() {
        super.init(window: nil)
        
        let window = NSWindow(contentRect: .zero, styleMask: [.titled, .closable, .resizable, .miniaturizable], backing: .buffered, defer: false)
        window.title = "Down"
        window.contentViewController = viewController
        
        self.window = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported.")
    }
}
