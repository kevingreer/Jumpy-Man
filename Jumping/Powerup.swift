//
//  Powerup.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 7/12/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

protocol Powerup {
  
//  var activeNode: SKNode {get set}
//  var movingNode: SKNode {get set}
  
  func applyToHero(h: Hero)
  func removeFromHero(h: Hero)
  func spawnMovingNode(speed: CGFloat, timeInterval: NSTimeInterval, point: CGPoint, scene: SKScene)
}
