//
//  SKNode+XSprite.swift
//  XSpriteDemo
//
//  Created by Matthew Reagan on 11/25/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

typealias NodeActionBlock = (SKNode) -> Void

struct AssociatedObjectKeys {
    static var onClickDown: UInt8 = 0
    static var onClickUp: UInt8 = 0
    static var onClickDragged: UInt8 = 0
}

extension SKNode {
    var onClickDown: NodeActionBlock? {
        get {
            return getAssociatedActionBlock(forKey: &AssociatedObjectKeys.onClickDown)
        }
        set {
            setAssociatedActionBlock(newValue, forKey: &AssociatedObjectKeys.onClickDown)
        }
    }
    
    func nearestAncenstorOnClickDown() -> SKNode? {
        return nearestAncestorWithActionBlock(forKey: &AssociatedObjectKeys.onClickDown)
    }
    
    var onClickUp: NodeActionBlock? {
        get {
            return getAssociatedActionBlock(forKey: &AssociatedObjectKeys.onClickUp)
        }
        set {
            setAssociatedActionBlock(newValue, forKey: &AssociatedObjectKeys.onClickUp)
        }
    }
    
    func nearestAncenstorOnClickUp() -> SKNode? {
        return nearestAncestorWithActionBlock(forKey: &AssociatedObjectKeys.onClickUp)
    }
    
    var onClickDragged: NodeActionBlock? {
        get {
            return getAssociatedActionBlock(forKey: &AssociatedObjectKeys.onClickDragged)
        }
        set {
            setAssociatedActionBlock(newValue, forKey: &AssociatedObjectKeys.onClickDragged)
        }
    }
    
    func nearestAncenstorOnClickDragged() -> SKNode? {
        return nearestAncestorWithActionBlock(forKey: &AssociatedObjectKeys.onClickDragged)
    }
    
    func nearestAncestorWithActionBlock(forKey key: UnsafeRawPointer) -> SKNode? {
        var aParent: SKNode? = parent
        while aParent != nil, aParent is SKScene == false  {
            if let _ = aParent?.getAssociatedActionBlock(forKey: key) {
                return aParent
            }
            
            aParent = aParent?.parent
        }
        
        return nil
    }
    
    func getAssociatedActionBlock(forKey key: UnsafeRawPointer) -> NodeActionBlock? {
        return objc_getAssociatedObject(self, key) as? NodeActionBlock
    }
    
    func setAssociatedActionBlock(_ actionBlock: NodeActionBlock?, forKey key: UnsafeRawPointer) {
        objc_setAssociatedObject(self,
                                 key,
                                 actionBlock,
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
}
