//
//  GameScene.swift
//  testSnake
//
//  Created by Max Li on 22.03.2021.
//

import SpriteKit
import GameplayKit

struct CollisionCategory {
    
    static let Snake: UInt32 = 0x1 << 0
    static let SnakeHead: UInt32 = 0x1 << 1
    static let Apple: UInt32 = 0x1 << 2
    static let EdgeBody: UInt32 = 0x1 << 3
    
}

class GameScene: SKScene {
    
    var snake: Snake?
   
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.darkGray
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.allowsRotation = false
        
        view.showsPhysics = true
        
        let counterClockwiseButton = SKShapeNode()
        
        counterClockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        counterClockwiseButton.position = CGPoint(x: view.scene!.frame.minX+30, y: view.scene!.frame.minY+30)
        counterClockwiseButton.fillColor = UIColor.black
        counterClockwiseButton.strokeColor = UIColor.green
        counterClockwiseButton.lineWidth = 10
        
        counterClockwiseButton.name = "counterClockwiseButton"
        
        self.addChild(counterClockwiseButton)
        
        let clockwiseButton = SKShapeNode()
        
        clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
        clockwiseButton.position = CGPoint(x: view.scene!.frame.maxX-70, y: view.scene!.frame.minY+30)
        clockwiseButton.fillColor = UIColor.black
        clockwiseButton.strokeColor = UIColor.green
        clockwiseButton.lineWidth = 10
        
        clockwiseButton.name = "clockwiseButton"
        
        self.addChild(clockwiseButton)
        
        createApple()
        
        snake = Snake(atPoint: CGPoint(x:view.scene!.frame.midX, y:view.scene!.frame.midY))
        
        self.addChild(snake!)
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCategory.EdgeBody
        self.physicsBody?.collisionBitMask = CollisionCategory.Snake | CollisionCategory.SnakeHead

    }
    
    func createApple(){
        
        let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX-10)))
        let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY-10)))
        
        let apple = Apple(position: CGPoint(x: randX, y: randY))
        self.addChild(apple)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard  let touchesNode = self.atPoint(touchLocation) as? SKShapeNode, touchesNode.name == "counterClockwiseButton" || touchesNode.name == "clockwiseButton" else {
                return
            }
            
            touchesNode.fillColor = .lightGray
            
            if touchesNode.name == "counterClockwiseButton" {
                snake!.moveCounterClockWisw()
            }else if touchesNode.name == "clockwiseButton" {
                snake!.moveClockWise()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            
            guard  let touchesNode = self.atPoint(touchLocation) as? SKShapeNode, touchesNode.name == "counterClockwiseButton" || touchesNode.name == "clockwiseButton" else {
                return
            }
            
            touchesNode.fillColor = .black
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        snake!.move()
    
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        let collesionObject = bodyes - CollisionCategory.SnakeHead
        
        switch collesionObject {
        case CollisionCategory.Apple:
            let apple = contact.bodyA.node is Apple ? contact.bodyA
                .node : contact.bodyB.node
            snake?.addBodyPart()
            apple?.removeFromParent()
            createApple()
        case CollisionCategory.EdgeBody:
        //home
        break
        
        default:
            break

        }
    }
    
}
