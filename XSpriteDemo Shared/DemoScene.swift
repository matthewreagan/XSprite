//
//  DemoScene.swift
//  XSpriteDemo
//
//  Created by Matthew Reagan on 11/25/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

var xDirection: CGFloat = 3.0
var yDirection: CGFloat = 3.0
let bubbleStart = CGPoint(x: 128, y: 128)

class DemoScene: GameScene {
    
    let bubbleNode = SKSpriteNode.init(imageNamed: "bubbleIcon")
    let potionNode = SKSpriteNode.init(imageNamed: "potionIcon")
    let centerSquare = SKSpriteNode.init(color: SKColor.red, size: .init(width: 32.0, height: 32.0))
    let demoLabel = SKLabelNode()
    let infoLabel = SKLabelNode()
    
    // MARK: - Setup
    
    override func setUpScene() {
        super.setUpScene()
        
        centerSquare.alpha = 0.5
        centerSquare.onShouldComputeDefaultPositionForSceneSize = {
            size in
            return CGPoint.init(x: size.width / 2.0, y: size.height / 2.0)
        }
        
        demoLabel.fontName = "Helvetica"
        demoLabel.fontColor = SKColor.red
        demoLabel.fontSize = 15.0
        demoLabel.horizontalAlignmentMode = .left
        demoLabel.verticalAlignmentMode = .bottom
        demoLabel.position = CGPoint(x: 20.0, y: 25.0)
        
        infoLabel.fontName = "Helvetica"
        infoLabel.fontColor = SKColor.gray
        infoLabel.fontSize = 13.0
        infoLabel.horizontalAlignmentMode = .left
        infoLabel.verticalAlignmentMode = .bottom
        infoLabel.position = CGPoint(x: 20.0, y: 10.0)
        infoLabel.text = "Try clicking the bubble or potion to see relationship between parent/child click actions"
        
        bubbleNode.onShouldComputeDefaultPositionForSceneSize = {
            size in
            return bubbleStart
        }
        
        potionNode.size = .init(width: 64.0, height: 64.0)
        potionNode.texture?.filteringMode = .nearest
        potionNode.run(.repeatForever(.rotate(byAngle: 2 * CGFloat.pi, duration: 3.0)))
        potionNode.onClickDown = {
            let spinnyAction = SKAction.rotate(byAngle: 2 * CGFloat.pi * 2, duration: 0.35)
            spinnyAction.timingMode = .easeInEaseOut
            $0.run(spinnyAction)
        }
        
        bubbleNode.onClickDown = {
            let zoomAction = SKAction.sequence([.scale(to: 1.5, duration: 0.1), .scale(to: 1.0, duration: 0.1)])
            $0.run(zoomAction)
        }
        
        bubbleNode.addChild(potionNode)
        addChildren([centerSquare, bubbleNode, demoLabel, infoLabel])
    }
    
    // MARK: - Click overrides
    
    override func handleClickDown(at location: CGPoint) -> Bool {
        
        // Allow default click handlers to run if needed, otherwise perform our custom click handling
        if !super.handleClickDown(at: location) {
            createClickCircle(at: location)
        }
        
        return false
    }
    
    override func handleClickDragged(at location: CGPoint) -> Bool {
        
        // Allow default click handlers to run if needed, otherwise perform our custom click handling
        if !super.handleClickDragged(at: location) {
            createClickCircle(at: location)
        }
        
        return false
    }
    
    func createClickCircle(at location: CGPoint) {
        let circleSize = 48.0
        let clickCircle = SKShapeNode.init(ellipseIn: .init(x: -circleSize/2.0, y: -circleSize/2.0, width: circleSize, height: circleSize))
        clickCircle.fillColor = SKColor.clear
        clickCircle.strokeColor = SKColor.magenta
        clickCircle.lineWidth = 2.0
        
        clickCircle.run(.sequence([.group([.scale(to: 1.5, duration: 0.3),
                                           .fadeOut(withDuration: 0.3)]),
                                   .removeFromParent()]))
        clickCircle.position = location
        
        addChild(clickCircle)
    }
    
    // MARK: - Logic
    
    override func update(_ currentTime: TimeInterval) {
        
        let bouncingNode = bubbleNode
        
        bouncingNode.position = CGPoint.init(x: bouncingNode.position.x + xDirection, y: bouncingNode.position.y + yDirection)
        let maxX = bouncingNode.position.x + bouncingNode.size.width / 2.0
        let maxY = bouncingNode.position.y + bouncingNode.size.height / 2.0
        let minX = bouncingNode.position.x - bouncingNode.size.width / 2.0
        let minY = bouncingNode.position.y - bouncingNode.size.height / 2.0
        
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
        demoLabel.text = "Scene size: \(Int(self.size.width)), \(Int(self.size.height))"
    }
}
