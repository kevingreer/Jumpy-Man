//
//  DoubleJump.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 7/12/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

class DoubleJump: NSObject, Powerup {
  
  var hero: Hero!
  let activeNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeZero)
  let movingNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(50, 50))
  var timer: NSTimer!
  
  let InitialDuration = 10
  
  var duration: Int = 10
  
  override init() {
    super.init()
    
  }
  
  func fireTimer(sender: NSTimer) {
    duration--
    println(duration)
    if duration == 0 {
      self.removeFromHero(hero)
    }
  }
  
  
  func applyToHero(h: Hero){
    if h.doubleJump == nil {
      self.hero = h
      self.activeNode.size = CGSizeMake(h.size.height, h.size.height)
      self.activeNode.alpha = 0.4
      self.activeNode.zPosition = 1
      h.addChild(self.activeNode)
      h.doubleJump = self
      timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
    } else {
      h.doubleJump!.duration += InitialDuration
    }
  }
  
  func removeFromHero(h: Hero) {
    self.activeNode.removeFromParent()
    h.doubleJump = nil
    timer.invalidate()
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
    
    movingNode.name = "DoubleJump"
  }
}