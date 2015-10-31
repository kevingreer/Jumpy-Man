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
  
  let InitialImpulse: CGFloat = 725
  let Force: CGFloat = 625
  
  var isJumping = false
  var isApplyingForce = false
  var numJump = 0
  
  var prevPosition: CGPoint!
  
  var isDead = false
  
  var storedVelocity: CGVector?
  
  //Power-ups
  var shield: Shield?
  var doubleJump: DoubleJump?
  
  //Textures
  var idleTexture: SKTexture = SKTexture(imageNamed: "ManIdle")
  var runTexture1: SKTexture = SKTexture(imageNamed: "ManRunning1")
  var runTexture2: SKTexture = SKTexture(imageNamed: "ManRunning2")
  var runTexture3: SKTexture = SKTexture(imageNamed: "ManRunning3")
  let jumpingTexture1: SKTexture = SKTexture(imageNamed: "ManJumping1")
  let jumpingTexture2: SKTexture = SKTexture(imageNamed: "ManJumping2")
  var runTextures = Array<SKTexture>()
  
  var run_anim: SKAction!
  
  ///Constructor: creates a Man and his physicsBody of appropriate size from a texture, color, and size
  init() {
    super.init(texture: idleTexture, color: UIColor.clearColor(), size: idleTexture.size())
    self.size = CGSizeMake(140,169)
    self.texture = idleTexture
    self.physicsBody = SKPhysicsBody(texture: jumpingTexture1, alphaThreshold: 0.1, size: self.size)
    self.physicsBody?.categoryBitMask = PhysicsCategory.Man
    self.physicsBody?.contactTestBitMask = PhysicsCategory.Barrel | PhysicsCategory.Powerup
    
    self.physicsBody?.allowsRotation = false
    self.physicsBody?.restitution = 0
    self.physicsBody?.friction = 0
    self.physicsBody?.linearDamping = 0
    self.physicsBody?.angularDamping = 0
    
    for i in  1...8{
      let string = "HeroRunning\(i)"
      let texture = SKTexture(imageNamed: string)
      runTextures.append(texture)
    }
    
    run_anim = SKAction.animateWithTextures(runTextures, timePerFrame: 0.05)
    self.runAction(SKAction.repeatActionForever(run_anim))
    
    self.prevPosition = self.position
    
    self.name = "Hero"

  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  ///Causes the Man to jump a given amount
  ///@param impulse = the impulse to be applied to the Man
  func jump() {
    numJump++
    isJumping = true
    self.removeAllActions()
    
    let currentTexture = self.texture
    for i in 0...runTextures.count-1 {
      if currentTexture == runTextures[i]{
        self.texture = runTextures[(i+1) % runTextures.count]
        break
      }
    }
    
    self.physicsBody?.velocity = CGVectorMake(0, 0)
    self.physicsBody?.applyImpulse(CGVectorMake(0.0, InitialImpulse))
  }
  
  /// Performs the appropriate actions for landing
  func land() {
    numJump = 0
    isJumping = false
    run()
  }
  
  ///Sets the Man's animation to the running animation
  func run() {
    self.removeAllActions()
    self.runAction(SKAction.repeatActionForever(run_anim))
  }
  
  /** Causes the `Hero` to stop and perform the dying animation
  *   If the `Hero` has a shield, it will be removed and he won't die */
  func hit() {
    print("HIT")
    self.physicsBody?.velocity = CGVectorMake(0, self.physicsBody!.velocity.dy)
    if shield != nil {
      shield!.removeFromHero(self)
    } else {
      die()
    }
  }
  
  /// Stops what the `Hero` is doing and causes him to perform the dying animation
  func die (){
    self.removeAllActions()
    self.physicsBody?.velocity = CGVectorMake(0, 0)
    self.runAction(SKAction.rotateByAngle(3.14159*2, duration: 2))
    self.physicsBody?.applyImpulse(CGVectorMake(0.0, InitialImpulse))
    self.physicsBody?.collisionBitMask = PhysicsCategory.None
    self.zPosition = 1
    isDead = true
//    self.runAction(SKAction.move)
//    self.texture = runTexture2
//    self.physicsBody = nil

  }
  
  /// Apply the appropriate force to the `Hero`
  func applyForce(){
    self.physicsBody?.applyForce(CGVectorMake(0.0, Force))
  }
  
  func manageJumpChange() {
//    if self.physicsBody?.velocity.dy > 0 {
//      self.texture = jumpingTexture1
//    } else {
//      self.texture = jumpingTexture2
//    }
  }

}
