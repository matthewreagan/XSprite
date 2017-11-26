//
//  GameScene.swift
//  XSpriteDemo Shared
//
//  Created by Matthew Reagan on 11/12/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    func setUpScene() {
        self.scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
    }
}

extension GameScene {
    // Shared cross-platform click handling
    
    func handleClickDown(at location: CGPoint) {
        for aNode in nodes(at: location) {
            if let clickDownActionBlock = aNode.onClickDown {
                clickDownActionBlock(aNode)
            }
        }
    }
    
    func handleClickUp(at location: CGPoint) {
        for aNode in nodes(at: location) {
            if let clickUpActionBlock = aNode.onClickUp {
                clickUpActionBlock(aNode)
            }
        }
    }
}

#if os(iOS)
    // Touch-based event handling
    extension GameScene {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                handleClickDown(at: touchLocation)
            }
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                handleClickUp(at: touchLocation)
            }
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                handleClickUp(at: touchLocation)
            }
        }
    }
#elseif os(OSX)
    // Mouse-based event handling
    extension GameScene {
        
        override func mouseDown(with event: NSEvent) {
            let touchLocation = event.location(in: self)
            handleClickDown(at: touchLocation)
        }
        
        override func mouseDragged(with event: NSEvent) {
        }
        
        override func mouseUp(with event: NSEvent) {
            let touchLocation = event.location(in: self)
            handleClickUp(at: touchLocation)
        }
    }
#endif

