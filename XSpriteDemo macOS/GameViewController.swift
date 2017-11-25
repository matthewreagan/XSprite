//
//  GameViewController.swift
//  XSpriteDemo macOS
//
//  Created by Matthew Reagan on 11/12/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    
    // MARK: - View Controller Overrides
    
    override func loadView() {
        let skView = SKView()
        
        view = skView
        let scene = DemoScene()
        
        skView.presentScene(scene)
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override func viewWillTransition(to newSize: NSSize) {
        super.viewWillTransition(to: newSize)
        
        skView()?.scene?.size = newSize
    }
    
    // MARK: - Public Convenience
    
    func skView() -> SKView? {
        return view as? SKView
    }
}

