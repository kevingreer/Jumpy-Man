//
//  Shield.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 7/12/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

class Shield: NSObject, Powerup {
  
  let node = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeZero)
  let movingNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(50, 50))
  
  func applyToHero(h: Hero){
    if h.shield == nil {
      self.node.size = CGSizeMake(h.size.height, h.size.height)
      self.node.alpha = 0.4
      self.node.zPosition = 1
      h.addChild(self.node)
      h.shield = self
    }
  }
  
  func removeFromHero(h: Hero) {
    self.node.removeFromParent()
    h.shield = nil
  }
  
  func spawnMovingNode(speed: CGFloat, timeInterval: NSTimeInterval, point: CGPoint, scene: SKScene){
    movingNode.position = point
    movingNode.physicsBody = SKPhysicsBody(circleOfRadius: movingNode.size.height)
    
    movingNode.physicsBody?.affectedByGravity = false
    movingNode.physicsBody?.categoryBitMask = PhysicsCategory.Powerup
    let movement = SKAction.moveByX(speed, y: 0, duration: timeInterval)
    movingNode.runAction(SKAction.repeatActionForever(movement))
    scene.addChild(movingNode)
    movingNode.zPosition = 1
    
    movingNode.name = "Shield"
  }
}
