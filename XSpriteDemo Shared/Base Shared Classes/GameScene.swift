//
//  GameScene.swift
//  XSpriteDemo Shared
//
//  Created by Matthew Reagan on 11/12/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var currentNodeTrackingClick: SKNode? = nil
    
    func setUpScene() {
        self.scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        var childrenToReposition: [SKNode] = children
        let newSceneSize = size
        
        while childrenToReposition.count > 0 {
            let child = childrenToReposition[0]
            childrenToReposition.removeFirst()
            if let computedDefaultPositionBlock = child.computedDefaultPositionForSceneSize {
                child.position = computedDefaultPositionBlock(newSceneSize)
            }
            
            childrenToReposition.append(contentsOf: child.children)
        }
    }
    
    // MARK: - Shared cross-platform click handling
    
    func handleClickDown(at location: CGPoint) -> Bool {
        for aNode in nodes(at: location) {
            if let clickDownActionBlock = aNode.onClickDown {
                clickDownActionBlock(aNode)
                currentNodeTrackingClick = aNode
                return true
            } else {
                if let nearestAncestorWithAction = aNode.nearestAncenstorOnClickDown() {
                    nearestAncestorWithAction.onClickDown?(nearestAncestorWithAction)
                    currentNodeTrackingClick = nearestAncestorWithAction
                    return true
                }
            }
        }
        
        return false
    }
    
    func handleClickUp(at location: CGPoint) -> Bool {
        
        if let clickTrackingNode = currentNodeTrackingClick {
            clickTrackingNode.onClickUp?(clickTrackingNode)
            currentNodeTrackingClick = nil
            return true
        } else {
            for aNode in nodes(at: location) {
                if let clickUpActionBlock = aNode.onClickUp {
                    clickUpActionBlock(aNode)
                    return true
                } else {
                    if let nearestAncestorWithAction = aNode.nearestAncenstorOnClickUp() {
                        nearestAncestorWithAction.onClickUp?(nearestAncestorWithAction)
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func handleClickDragged(at location: CGPoint) -> Bool {
        let nodesAtLocation =  nodes(at: location)
        
        if let clickTrackingNode = currentNodeTrackingClick {
            if nodesAtLocation.contains(clickTrackingNode) {
                clickTrackingNode.onClickDragged?(clickTrackingNode)
            }
            
            return true
        } else {
            for aNode in nodesAtLocation {
                if let clickDraggedActionBlock = aNode.onClickDragged {
                    clickDraggedActionBlock(aNode)
                    return true
                } else {
                    if let nearestAncestorWithAction = aNode.nearestAncenstorOnClickDragged() {
                        nearestAncestorWithAction.onClickDragged?(nearestAncestorWithAction)
                        return true
                    }
                }
            }
        }
        
        return false
    }
}

#if os(iOS)
    // Touch-based event handling
    extension GameScene {
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                _ = handleClickDown(at: touchLocation)
            }
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                _ = handleClickDragged(at: touchLocation)
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                _ = handleClickUp(at: touchLocation)
            }
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                _ = handleClickUp(at: touchLocation)
            }
        }
    }
#elseif os(OSX)
    // Mouse-based event handling
    extension GameScene {
        
        override func mouseDown(with event: NSEvent) {
            let touchLocation = event.location(in: self)
            _ = handleClickDown(at: touchLocation)
        }
        
        override func mouseDragged(with event: NSEvent) {
            let touchLocation = event.location(in: self)
            _ = handleClickDragged(at: touchLocation)
        }
        
        override func mouseUp(with event: NSEvent) {
            let touchLocation = event.location(in: self)
            _ = handleClickUp(at: touchLocation)
        }
    }
#endif

