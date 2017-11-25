//
//  AppDelegate.swift
//  XSpriteDemo macOS
//
//  Created by Matthew Reagan on 11/12/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    var mainWindow: NSWindow?
    let defaultResolution : NSSize = NSSize(width: 1024.0, height: 768.0)
    let defaultMinimumSize : NSSize = NSSize(width: 512.0, height: 384.0)
    let gameViewController = GameViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let defaultFrame = NSRect(x: 0.0,
                                  y: 0.0,
                                  width: defaultResolution.width,
                                  height: defaultResolution.height)
        
        
        let window = NSWindow.init(contentRect: defaultFrame,
                                   styleMask: [.titled, .resizable],
                                   backing: .buffered,
                                   defer: true)
        
        window.minSize = defaultMinimumSize
        mainWindow = window
        window.delegate = self
        
        window.contentViewController?.addChildViewController(gameViewController)
        window.contentView?.addSubview(gameViewController.view)
        gameViewController.skView()?.frame = defaultFrame
        gameViewController.skView()?.autoresizingMask = [.width, .height]
        gameViewController.skView()?.scene?.size = defaultResolution
        
        window.center()
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - NSWindowDelegate
    
    func windowDidResize(_ notification: Notification) {
        if let gameWindow = mainWindow,
            let scene = gameViewController.skView()?.scene {
            scene.size = gameWindow.frame.size
        }
    }
}

