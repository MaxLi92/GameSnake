//
//  SnakeHead.swift
//  testSnake
//
//  Created by Max Li on 03.04.2021.
//

import UIKit
import SpriteKit

class SnakeHead: SnakeBodyPart {
    
    override init (atPoint point: CGPoint){
        super.init(atPoint: point)
        
        self.physicsBody?.categoryBitMask = CollisionCategory.SnakeHead
        self.physicsBody?.contactTestBitMask = CollisionCategory.EdgeBody | CollisionCategory.Apple | CollisionCategory.Snake
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
}
