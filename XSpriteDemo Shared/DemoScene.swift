//
//  DemoScene.swift
//  XSpriteDemo
//
//  Created by Matthew Reagan on 11/25/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

class DemoScene: GameScene {
    
    let demoNode = SKSpriteNode.init(imageNamed: "potionIcon")
    let demoLabel = SKLabelNode()
    var xDirection: CGFloat = 4.0
    var yDirection: CGFloat = 4.0
    
    // MARK: - Setup
    
    override func setUpScene() {
        super.setUpScene()
        
        self.addChild(demoNode)
        self.addChild(demoLabel)
        demoLabel.fontName = "Helvetica"
        demoLabel.fontColor = SKColor.red
        demoLabel.fontSize = 15.0
        demoLabel.horizontalAlignmentMode = .left
        demoLabel.position = CGPoint(x: 20.0, y: 20.0)
        demoNode.position = CGPoint(x: 100, y: 100)
        
        demoNode.size = .init(width: 64.0, height: 64.0)
        demoNode.texture?.filteringMode = .nearest
        demoNode.run(.repeatForever(.rotate(byAngle: 2 * CGFloat.pi, duration: 3.0)))
        
        demoNode.onClickDown = {
            let spinnyAction = SKAction.rotate(byAngle: 2 * CGFloat.pi * 2, duration: 0.35)
            spinnyAction.timingMode = .easeInEaseOut
            $0.run(spinnyAction)
        }
    }
    
    // MARK: - Logic
    
    override func update(_ currentTime: TimeInterval) {
        // For simple demo
        demoNode.position = CGPoint.init(x: demoNode.position.x + xDirection, y: demoNode.position.y + yDirection)
        let maxX = demoNode.position.x + demoNode.size.width / 2.0
        let maxY = demoNode.position.y + demoNode.size.height / 2.0
        let minX = demoNode.position.x - demoNode.size.width / 2.0
        let minY = demoNode.position.y - demoNode.size.height / 2.0
        
        if maxX >= scene!.size.width || minX <= 0.0 {
            xDirection *= -1.0
        }
        
        if maxY >= scene!.size.height || minY <= 0.0 {
            yDirection *= -1.0
        }
    }
    
    // MARK: - Sizing
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        demoNode.position = .init(x: 100.0, y: 100.0)
        demoLabel.text = "Scene size: \(Int(self.size.width)), \(Int(self.size.height))"
    }
}
