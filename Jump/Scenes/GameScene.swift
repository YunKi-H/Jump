//
//  GameScene.swift
//  Jump
//
//  Created by 매미 on 2022/03/19.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Properties
    private let worldNode = SKNode()
    private var bgNode: SKSpriteNode!
    
    private let playerNode = PlayerNode(diff: 0)
    private let wallNode = WallNode()
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstaclesNode = SKNode()
    
    private var firstTap = true
    private var posY: CGFloat = 0.0
    private var pairNum = 0
    
    //MARK: - Lifecycle
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        if firstTap {
            playerNode.activate(true)
            firstTap = false 
        }
        
        let location = touch.location(in: self)
        let right = !(location.x > frame.width / 2)
        
        playerNode.jump(right)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

//MARK: - Setups

extension GameScene {
    
    private func setupNodes() {
        backgroundColor = .white
        setupPhysics()
        
        //TODO: - BackgroundNode
        addBG()
        
        //TODO: - WorldNode
        addChild(worldNode)
        
        //TODO: - PlayerNode
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY * 0.6)
        worldNode.addChild(playerNode)
        
        //TODO: - WallNode
        addWall()
        
        //TODO: - ObstaclesNode
        worldNode.addChild(obstaclesNode)
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -15.0)
        physicsWorld.contactDelegate = self
    }
}

//MARK: - BackgroundNode

extension GameScene {
    
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode)
    }
}

//MARK: - WallNode

extension GameScene {
    
    private func addWall() {
        wallNode.position = CGPoint(x: frame.midX, y: 0.0)
        leftNode.position = CGPoint(x: playableRect.minX, y: frame.midY)
        rightNode.position = CGPoint(x: playableRect.maxX, y: frame.midY)
        
        addChild(wallNode)
        addChild(leftNode)
        addChild(rightNode)
    }
}

//MARK: - ObstaclesNode

extension GameScene {
    
    private func addObstackes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: 0.0, y: frame.midY)
        pipePair.zPosition = 1.0
        pipePair.name = "Pair"
        
        let size = CGSize(width: screenWidth, height: 50.0)
        let pipe_1 = SKSpriteNode(color: .black, size: size)
        pipe_1.position = CGPoint(x: -250, y: 0.0)
        pipe_1.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_1.physicsBody?.isDynamic = false
        pipe_1.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let pipe_2 = SKSpriteNode(color: .black, size: size)
        pipe_2.position = CGPoint(x: pipe_1.position.x + size.width + 250, y: 0.0)
        pipe_2.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_2.physicsBody?.isDynamic = false
        pipe_2.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        pipePair.addChild(pipe_1)
        pipePair.addChild(pipe_2)
        
        obstaclesNode.addChild(pipePair)
    }
}

extension GameScene {
    
    private func gameOver() {
        playerNode.over()
    }
}

//MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicsCategories.Player ? contact.bodyB : contact.bodyA
        
        switch body.categoryBitMask {
        case PhysicsCategories.Wall:
            gameOver()
        case PhysicsCategories.Side:
            playerNode.side()
        case PhysicsCategories.Obstacles:
            gameOver()
        default: break
        }
    }
}
