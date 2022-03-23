//
//  PlayerNode.swift
//  Jump
//
//  Created by 매미 on 2022/03/20.
//

import SpriteKit

class PlayerNode: SKNode {
    
    //MARK: - Properties
    private var player: SKShapeNode!
    private var diff = 0
    private let radius: CGFloat = 30.0
    
    //MARK: - Initializes
    init(diff: Int) {
        super.init()
        self.diff = diff
        
        self.name = "Player"
        self.zPosition = 10.0
        
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setups
extension PlayerNode {
    
    private func setupPhysics() {
        player = SKShapeNode(circleOfRadius: radius)
        player.name = "Player"
        player.zPosition = .pi
        player.fillColor = .red
        player.physicsBody = SKPhysicsBody(circleOfRadius: radius * 0.8)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.linearDamping = 0.0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.usesPreciseCollisionDetection = true
    }
}
