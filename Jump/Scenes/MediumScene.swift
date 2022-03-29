//
//  MediumScene.swift
//  Jump
//
//  Created by 매미 on 2022/03/30.
//

import SpriteKit
import GameplayKit

class MediumScene: SKScene {
    
    //MARK: - Properties
    private let worldNode = SKNode()
    private var bgNode: SKSpriteNode!
    private var hudNode = HUDNode()
    
    private let playerNode = PlayerNode(diff: 0)
    private let wallNode = WallNode()
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstaclesNode = SKNode()
    
    var firstTap = true
    private var posY: CGFloat = 0.0
    private var pairNum = 0
    private var score = 0
    
    lazy var colors: [ColorModel] = {
        return ColorModel.shared()
    }()
    
    private let jumpSound = SKAction.playSoundFileNamed(SoundName.jump, waitForCompletion: false)
    private let superScoreSound = SKAction.playSoundFileNamed(SoundName.superScore, waitForCompletion: false)
    private let collisionSound = SKAction.playSoundFileNamed(SoundName.collision, waitForCompletion: false)
    private let btnSound = SKAction.playSoundFileNamed(SoundName.btn, waitForCompletion: false)
    private let scoreSound = SKAction.playSoundFileNamed(SoundName.score, waitForCompletion: false)
    
    private let notifKey = "MediumNotifKey"
    private let scoreKey = "MediumScoreKey"
    
    private let requestScore = 30
    private let btnName = "icon-go"
    private let titleTxt = "Wow!!! You are great"
    private let subTxt = """
Continue 30 score
to plat next level
Trying!!!
"""
    
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
        let right = (location.x > frame.width / 2)
        
        playerNode.jump(right)
        run(jumpSound)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if -playerNode.height() + frame.midY < worldNode.position.y {
            worldNode.position.y = -playerNode.height() + frame.midY
        }
        
        if posY - playerNode.height() < frame.midY {
            addObstackes()
        }
        
        obstaclesNode.children.forEach {
            let i = score - 2
            if $0.name == "Pair\(i)" {
                $0.removeFromParent()
            }
        }
    }
}

//MARK: - Setups

extension MediumScene {
    
    private func setupNodes() {
        backgroundColor = .white
        setupPhysics()
        
        //TODO: - BackgroundNode
        addBG()
        
        //TODO: - HUDNode
        addChild(hudNode)
        hudNode.skView = view
        hudNode.mediumScene = self
        
        if !UserDefaults.standard.bool(forKey: notifKey) {
            UserDefaults.standard.set(true, forKey: notifKey)
            hudNode.setupPanel(subTxt: subTxt, titleTxt: titleTxt, btnName: btnName)
        }
        
        //TODO: - WorldNode
        addChild(worldNode)
        
        //TODO: - PlayerNode
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY * 0.6)
        worldNode.addChild(playerNode)
        
        //TODO: - WallNode
        addWall()
        
        //TODO: - ObstaclesNode
        worldNode.addChild(obstaclesNode)
        posY = frame.midY
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -15.0)
        physicsWorld.contactDelegate = self
    }
}

//MARK: - BackgroundNode

extension MediumScene {
    
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode)
    }
}

//MARK: - WallNode

extension MediumScene {
    
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

extension MediumScene {
    
    private func addObstackes() {
        let model = colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
        let model_1 = colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
        let randomX = CGFloat(arc4random() % UInt32(playableRect.width / 2))
        
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: 0.0, y: posY)
        pipePair.zPosition = 1.0
        
        pairNum += 1
        pipePair.name = "Pair\(pairNum)"
        
        let size = CGSize(width: screenWidth, height: 50.0)
        let pipe_1 = SKSpriteNode(color: model.color, size: size)
        pipe_1.position = CGPoint(x: randomX - 270, y: 0.0)
        pipe_1.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_1.physicsBody?.isDynamic = false
        pipe_1.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let pipe_2 = SKSpriteNode(color: model.color, size: size)
        pipe_2.position = CGPoint(x: pipe_1.position.x + size.width + 270, y: 0.0)
        pipe_2.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe_2.physicsBody?.isDynamic = false
        pipe_2.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let blockSize = CGSize(width: 30.0, height: 30.0)
        if pipePair.name != "Pair1" {
            let random = CGFloat(arc4random() % 4)
            let block = SKSpriteNode(color: model_1.color, size: blockSize)
            block.position = CGPoint(
                x: pipe_1.frame.maxX + ((random + 1) * 30),
                y: pipe_1.position.y - 130)
            block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
            pipePair.addChild(block)
        }
        
        let random = CGFloat(arc4random() % 4)
        let block = SKSpriteNode(color: model_1.color, size: blockSize)
        block.position = CGPoint(
            x: pipe_1.frame.maxX + ((random + 1) * 30),
            y: pipe_1.position.y + 130)
        block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
        block.physicsBody?.isDynamic = false
        block.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        pipePair.addChild(block)
        
        let score = SKNode()
        score.position = CGPoint(x: 0.0, y: size.height)
        score.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: size.height))
        score.physicsBody?.isDynamic = false
        score.physicsBody?.categoryBitMask = PhysicsCategories.Score
        
        pipePair.addChild(pipe_1)
        pipePair.addChild(pipe_2)
        pipePair.addChild(score)
        
        obstaclesNode.addChild(pipePair)
        
        switch arc4random_uniform(100) {
        case 0...80: break
        default: addSuperScore()
        }
        
        posY += frame.midY * 0.7
    }
    
    private func addSuperScore() {
        let node = SuperScoreNode()
        let randomX = playableRect.midX + CGFloat(arc4random_uniform(UInt32(playableRect.width / 2))) + node.frame.width
        let randomY = posY + CGFloat(arc4random_uniform(UInt32(posY * 0.5))) + node.frame.height
        node.position = CGPoint(x: randomX, y: randomY)
        
        worldNode.addChild(node)
        node.bounce()
    }
}

//MARK: - GameState

extension MediumScene {
    
    private func gameOver() {
        playerNode.over()
        
        var highscore = UserDefaults.standard.integer(forKey: scoreKey)
        if score > highscore {
            highscore = score
        }
        hudNode.setupGameOver(score, highscore)
        run(collisionSound)
    }
    
    private func success() {
        if score >= requestScore {
            playerNode.activate(false)
            hudNode.setUpSuccess()
            
            //Unlock HardScene
        }
    }
}

//MARK: - SKPhysicsContactDelegate

extension MediumScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicsCategories.Player ? contact.bodyB : contact.bodyA
        
        switch body.categoryBitMask {
        case PhysicsCategories.Wall:
            gameOver()
        case PhysicsCategories.Side:
            playerNode.side()
        case PhysicsCategories.Obstacles:
            gameOver()
        case PhysicsCategories.Score:
            if let node = body.node {
                score += 1
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: scoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: scoreKey)
                }
                
                run(scoreSound)
                node.removeFromParent()
                success()
            }
        case PhysicsCategories.SuperScore:
            if let node = body.node {
                score += 5
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: scoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: scoreKey)
                }
                
                run(superScoreSound)
                node.removeFromParent()
                success()
            }
        default: break
        }
    }
}

