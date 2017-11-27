//
//  SKAction+Utilities.swift
//  XSpriteDemo
//
//  Created by Matthew Reagan on 11/26/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

extension SKAction {
    func withTimingMode(_ newTimingMode: SKActionTimingMode) -> SKAction {
        timingMode = newTimingMode
        return self
    }
}
