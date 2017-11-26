//
//  File.swift
//  XSpriteDemo
//
//  Created by Matthew Reagan on 11/26/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import SpriteKit

extension SKNode {
    func centerInScene() {
        if let myScene = scene {
            let sceneSize = myScene.size
            position = .init(x: round(sceneSize.width / 2.0), y: round(sceneSize.height / 2.0))
        }
    }
}
