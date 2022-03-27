//
//  SideNode.swift
//  Jump
//
//  Created by 매미 on 2022/03/27.
//

import SpriteKit

class SideNode: SKNode {
    
    //MARK: - Properties
    private var node: SKSpriteNode!
    private var diff = 0
    private let radius: CGFloat = 30.0
    
    //MARK: - Initializes
    override init() {
        super.init()
        self.name = "Side"
        self.zPosition = 5.0
        
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setups
extension SideNode {
    
    private func setupPhysics() {
        let size = CGSize(width: 40.0, height: screenHeight)
        node = SKSpriteNode(color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 1.0
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = PhysicsCategories.Side
        addChild(node)
    }
}

