//
//  SKScene+Utilities.swift
//  XSpriteDemo
//
//  Created by Matthew Reagan on 11/26/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

extension SKScene {
    func addChildren(_ children: [SKNode]) {
        for child in children {
            addChild(child)
        }
    }
}
