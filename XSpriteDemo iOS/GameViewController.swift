//
//  GameViewController.swift
//  XSpriteDemo iOS
//
//  Created by Matthew Reagan on 11/12/17.
//  Copyright © 2017 MyOrganization. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    // MARK: - View Controller Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = DemoScene()
        let skView = SKView()
        
        view = skView
        skView.presentScene(scene)
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        skView()?.scene?.size = size
    }
    
    // MARK: - Public Convenience
    
    func skView() -> SKView? {
        return view as? SKView
    }
}
