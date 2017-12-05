//
//  GameScene.swift
//  XSpriteDemo Shared
//
//  Created by Matthew Reagan on 11/12/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

struct ClickEvent {
    let location: CGPoint
    let startLocation: CGPoint
}

class GameScene: SKScene {
    
    var currentNodeTrackingClick: SKNode? = nil
    var clickHasEnteredCurrentNodeTrackingClick: Bool = false
    var currentClickStart: CGPoint = .zero
    
    #if os(iOS)
    var currentTouch: UITouch? = nil
    #endif
    
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
    
    func handleClickDown(_ clickEvent: ClickEvent) -> Bool {
        for aNode in nodes(at: clickEvent.location) {
            if let clickDownActionBlock = aNode.onClickDown {
                clickDownActionBlock(aNode)
                currentNodeTrackingClick = aNode
                clickHasEnteredCurrentNodeTrackingClick = true
                return true
            } else {
                if let nearestAncestorWithAction = aNode.nearestAncenstorOnClickDown() {
                    nearestAncestorWithAction.onClickDown?(nearestAncestorWithAction)
                    currentNodeTrackingClick = nearestAncestorWithAction
                    clickHasEnteredCurrentNodeTrackingClick = true
                    return true
                }
            }
        }
        
        return false
    }
    
    func handleClickUp(_ clickEvent: ClickEvent) -> Bool {
        
        if let clickTrackingNode = currentNodeTrackingClick {
            if clickHasEnteredCurrentNodeTrackingClick {
                clickTrackingNode.onClickUp?(clickTrackingNode)
                clickHasEnteredCurrentNodeTrackingClick = false
            }
            currentNodeTrackingClick = nil
            return true
        } else {
            for aNode in nodes(at: clickEvent.location) {
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
    
    func handleClickDragged(_ clickEvent: ClickEvent) -> Bool {
        let nodesAtLocation =  nodes(at: clickEvent.location)
        
        if let clickTrackingNode = currentNodeTrackingClick {
            if nodesAtLocation.contains(clickTrackingNode) {
                if !clickHasEnteredCurrentNodeTrackingClick {
                    clickHasEnteredCurrentNodeTrackingClick = true
                    clickTrackingNode.onClickDragEntered?(clickTrackingNode)
                } else {
                    clickTrackingNode.onClickDragged?(clickTrackingNode)
                }
            } else {
                if clickHasEnteredCurrentNodeTrackingClick {
                    clickHasEnteredCurrentNodeTrackingClick = false
                    clickTrackingNode.onClickDragExited?(clickTrackingNode)
                }
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
            if currentTouch == nil {
                currentTouch = touches.first!
                let location = currentTouch!.location(in: self)
                currentClickStart = location
                let clickEvent = ClickEvent(location: location, startLocation: currentClickStart)
                _ = handleClickDown(clickEvent)
            }
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            if currentTouch != nil, touches.contains(currentTouch!) {
                let location = currentTouch!.location(in: self)
                let clickEvent = ClickEvent(location: location, startLocation: currentClickStart)
                _ = handleClickDragged(clickEvent)
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            handleTouchesEndedOrCancelled(touches)
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            handleTouchesEndedOrCancelled(touches)
        }
        
        func handleTouchesEndedOrCancelled(_ touches: Set<UITouch>) {
            if currentTouch != nil, touches.contains(currentTouch!) {
                let location = currentTouch!.location(in: self)
                let clickEvent = ClickEvent(location: location, startLocation: currentClickStart)
                _ = handleClickUp(clickEvent)
                currentClickStart = .zero
                currentTouch = nil
            }
        }
    }
#elseif os(OSX)
    // Mouse-based event handling
    extension GameScene {
        
        override func mouseDown(with event: NSEvent) {
            let location = event.location(in: self)
            currentClickStart = location
            let clickEvent = ClickEvent(location: location, startLocation: currentClickStart)
            _ = handleClickDown(clickEvent)
        }
        
        override func mouseDragged(with event: NSEvent) {
            let location = event.location(in: self)
            let clickEvent = ClickEvent(location: location, startLocation: currentClickStart)
            _ = handleClickDragged(clickEvent)
        }
        
        override func mouseUp(with event: NSEvent) {
            let location = event.location(in: self)
            let clickEvent = ClickEvent(location: location, startLocation: currentClickStart)
            _ = handleClickUp(clickEvent)
            currentClickStart = .zero
        }
    }
#endif

