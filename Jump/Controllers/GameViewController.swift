//
//  GameViewController.swift
//  Jump
//
//  Created by 매미 on 2022/03/19.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view as? SKView else {
            return
        }
        
        let scene = GameScene(size: CGSize(width: screenWidth, height: screenHeight))
        scene.scaleMode = .aspectFill
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        view.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
