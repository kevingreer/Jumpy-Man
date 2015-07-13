//
//  Barrel.swift
//  Jumping
//
//  Created by Kevin Greer on 1/7/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

///An SKSpriteNode with a point field to keep track of when a Character clears the Barrel.
class Barrel: SKSpriteNode {
  
  static let DefaultSpeed: CGFloat = 750
  static let FastSpeed: CGFloat = 2000
  
  var prevPosition: CGPoint!
  let Diameter: CGFloat = 125
  var dx: CGFloat!
  let barrelTexture = SKTexture(imageNamed: "Barrel")
  
  init(spawnPoint: CGPoint) {
    super.init(texture: barrelTexture, color: nil, size: barrelTexture.size())
    self.position = spawnPoint
    self.texture = barrelTexture
    self.size = CGSizeMake(Diameter, Diameter)
    let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:0.5)
    self.runAction(SKAction.repeatActionForever(action))
    self.physicsBody = SKPhysicsBody(circleOfRadius: Diameter/2)
    self.physicsBody?.categoryBitMask = PhysicsCategory.Barrel
    self.physicsBody?.contactTestBitMask = PhysicsCategory.Man
    self.physicsBody?.collisionBitMask = PhysicsCategory.Barrel | PhysicsCategory.Ground
//    let moveBarrel = SKAction.moveByX(-Speed, y: 0.0, duration: 1)
//    self.runAction(SKAction.repeatActionForever(moveBarrel))
    prevPosition = spawnPoint
    dx = Barrel.DefaultSpeed
    self.physicsBody?.velocity.dx = -dx
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func changeSpeed(dx: CGFloat){
    self.dx = dx
    self.physicsBody?.velocity.dx = -dx
  }
  
  func explode() {
    println("Explode!")
    self.physicsBody?.categoryBitMask = PhysicsCategory.None
    self.removeFromParent()
  }
}
