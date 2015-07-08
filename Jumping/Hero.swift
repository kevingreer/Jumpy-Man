//
//  Hero.swift
//  Jumping
//
//  Created by Kevin Greer on 1/15/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

///A Character that can must be able to run and jump. Just change textures for different characters. Enum of texture groups?
class Hero: SKSpriteNode {
  
  let InitialImpulse: CGFloat = 250
  let Force: CGFloat = 500
  
  var isJumping = false
  var isApplyingForce = false
  
  //Textures
  var idleTexture: SKTexture = SKTexture(imageNamed: "ManIdle")
  var runTexture1: SKTexture = SKTexture(imageNamed: "ManRunning1")
  var runTexture2: SKTexture = SKTexture(imageNamed: "ManRunning2")
  var runTexture3: SKTexture = SKTexture(imageNamed: "ManRunning3")
  let jumpingTexture1: SKTexture = SKTexture(imageNamed: "ManJumping1")
  let jumpingTexture2: SKTexture = SKTexture(imageNamed: "ManJumping2")
  
  var run_anim: SKAction!
  
  ///Constructor: creates a Man and his physicsBody of appropriate size from a texture, color, and size
  
  init() {
    super.init(texture: idleTexture, color: nil, size: idleTexture.size())
    self.setScale(0.75)
    self.texture = idleTexture
    self.physicsBody = SKPhysicsBody(texture: idleTexture, alphaThreshold: 0.1, size: self.size)
    self.physicsBody?.categoryBitMask = PhysicsCategory.Man
    self.physicsBody?.contactTestBitMask = PhysicsCategory.Barrel
    
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.restitution = 0
    self.physicsBody?.friction = 0
    self.physicsBody?.linearDamping = 0
    self.physicsBody?.angularDamping = 0
    
    run_anim = SKAction.animateWithTextures([runTexture3, idleTexture, runTexture1, runTexture2], timePerFrame: 0.09)
    run()
    self.name = "Hero"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  ///Causes the Man to jump a given amount
  ///@param impulse = the impulse to be applied to the Man
  func jump() {
    isJumping = true
    self.removeAllActions()
    self.physicsBody?.applyImpulse(CGVectorMake(0.0, InitialImpulse))
  }
  
  func land() {
    isJumping = false
    run()
  }
  
  ///Sets the Man's animation to the running animation
  func run() {
    self.removeAllActions()
    self.runAction(SKAction.repeatActionForever(run_anim))
  }
  
  ///Sets the Man's animation to the dead animation (not fully implemented)
  func die (){
    self.removeAllActions()
    self.texture = runTexture2
    self.runAction(SKAction.rotateByAngle(3.14159/2, duration: 0.25))
  }
  
  func applyForce(){
    self.physicsBody?.applyForce(CGVectorMake(0.0, Force))
  }
  
  func manageJumpChange() {
    if self.physicsBody?.velocity.dy > 0 {
      self.texture = jumpingTexture1
    } else {
      self.texture = jumpingTexture2
    }
  }

}
