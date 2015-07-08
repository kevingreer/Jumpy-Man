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
  
  //Textures
  var idleTexture: SKTexture = SKTexture(imageNamed: "ManIdle")
  var runTexture1: SKTexture = SKTexture(imageNamed: "ManRunning1")
  var runTexture2: SKTexture = SKTexture(imageNamed: "ManRunning2")
  var runTexture3: SKTexture = SKTexture(imageNamed: "ManRunning3")
  let jumpingTexture1: SKTexture = SKTexture(imageNamed: "ManJumping1")
  let jumpingTexture2: SKTexture = SKTexture(imageNamed: "ManJumping2")
  
  var run_anim: SKAction!
  
  ///Constructor: creates a Man and his physicsBody of appropriate size from a texture, color, and size
  override init(texture:SKTexture, color:SKColor, size:CGSize) {
    super.init(texture:texture, color:color, size:size)
//    self.setScale(0.33)
//    self.physicsBody = SKPhysicsBody(texture: idleTexture, size: self.size)
//    self.physicsBody?.categoryBitMask = PhysicsCategory.Man
//    self.physicsBody?.contactTestBitMask = PhysicsCategory.Barrel
//    self.physicsBody?.allowsRotation = false
//    self.physicsBody?.restitution = 0
    run_anim = SKAction.animateWithTextures([runTexture3, idleTexture, runTexture1, runTexture2], timePerFrame: 0.09)
    run()
    self.name = "Man"
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  //
  //    ///Constructor: creates a Man and his physicsBody of appropriate size
  //    required init?(coder aDecoder: NSCoder, node: SKSpriteNode) {
  //      super.init(coder: aDecoder)
  //      self.setScale(0.5)
  //      self.physicsBody = SKPhysicsBody(texture: idleTexture, size: self.size)
  //      self.physicsBody?.categoryBitMask = PhysicsCategory.Man
  //      self.physicsBody?.contactTestBitMask = PhysicsCategory.Barrel
  //      self.physicsBody?.allowsRotation = false
  //      self.physicsBody?.restitution = 0
  //      run_anim = SKAction.animateWithTextures([idleTexture, runTexture1, runTexture2, runTexture3], timePerFrame: 0.1)
  //      self.runAction(SKAction.repeatActionForever(run_anim))
  //      self.name = "Man"
  //    }
  //
  
  func setupMan(){
    run_anim = SKAction.animateWithTextures([runTexture3, idleTexture, runTexture1, runTexture2], timePerFrame: 0.09)
    run()
  }
  
  ///Causes the Man to jump a given amount
  ///@param impulse = the impulse to be applied to the Man
  func jump(impulse: CGFloat) {
    self.removeAllActions()
    let jump_anim = SKAction.animateWithTextures([jumpingTexture1, jumpingTexture2], timePerFrame: 0.25)
    self.runAction(SKAction.repeatAction(jump_anim, count: 1))
    self.physicsBody?.applyImpulse(CGVectorMake(0.0, impulse/6+1.4))
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
}
