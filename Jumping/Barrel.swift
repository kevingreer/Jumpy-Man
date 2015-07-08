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
  
  var prevPosition: CGPoint!
  let Diameter: CGFloat = 100
  let Speed: CGFloat = 500
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
    let moveBarrel = SKAction.moveByX(-Speed, y: 0.0, duration: 1)
    self.runAction(SKAction.repeatActionForever(moveBarrel))
    prevPosition = spawnPoint
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
