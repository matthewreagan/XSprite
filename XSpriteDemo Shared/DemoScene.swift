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
    
    let bubbleNode = SKSpriteNode(imageNamed: "bubbleIcon")
    let potionNode = SKSpriteNode(imageNamed: "potionIcon")
    let centerSquare = SKSpriteNode(color: SKColor.red, size: .init(width: 10.0, height: 10.0))
    let woodButton = SKSpriteNode(imageNamed: "woodButton")
    let demoLabel = SKLabelNode()
    let infoLabel = SKLabelNode()
    let buttonLabel = SKLabelNode()
    
    // MARK: - Setup
    
    override func setUpScene() {
        super.setUpScene()
        
        centerSquare.alpha = 0.5
        centerSquare.computedDefaultPositionForSceneSize = {
            size in
            return CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        }
        
        buttonLabel.fontName = "Helvetica Bold"
        buttonLabel.fontColor = SKColor.white
        buttonLabel.fontSize = 17.0
        buttonLabel.horizontalAlignmentMode = .center
        buttonLabel.verticalAlignmentMode = .bottom
        buttonLabel.position = CGPoint(x: 0.0, y: 0.0)
        buttonLabel.text = "Click me! I track the mouse!"
        buttonLabel.alpha = 0.75
        buttonLabel.blendMode = .add
        buttonLabel.position = .init(x: 0.0, y: -7.0)
        
        woodButton.computedDefaultPositionForSceneSize = {
            size in
            return CGPoint(x: round(size.width / 2.0) + 25.0, y: round(size.height / 2.0) - 100)
        }
        
        weak var weakWoodButton: SKSpriteNode? = woodButton
        woodButton.onClickDown = {
            $0.run(.scale(to: 0.9, duration: 0.02))
            weakWoodButton?.colorBlendFactor = 0.2
            weakWoodButton?.color = SKColor.black
        }
        
        woodButton.onClickUp = {
            $0.run(.scale(to: 1.0, duration: 0.02))
            weakWoodButton?.colorBlendFactor = 0.0
            weakWoodButton?.color = SKColor.white
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
        
        bubbleNode.computedDefaultPositionForSceneSize = {
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
        
        woodButton.run(.repeatForever(.sequence([SKAction.moveBy(x: -50, y: 0.0, duration: 1.0).withTimingMode(.easeInEaseOut),
                                                 SKAction.moveBy(x: 50, y: 0.0, duration: 1.0).withTimingMode(.easeInEaseOut)])))
        
        woodButton.addChild(buttonLabel)
        bubbleNode.addChild(potionNode)
        addChildren([centerSquare, bubbleNode, demoLabel, infoLabel, woodButton])
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
        clickCircle.zPosition = -1.0
        
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
