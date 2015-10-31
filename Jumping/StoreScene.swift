//
//  StoreScene.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 7/13/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

class StoreScene: SKScene {
  
  
  override func didMoveToView(view: SKView) {
    let bg = childNodeWithName("Background") as! SKSpriteNode
    bg.texture = SKTexture(imageNamed: "StoreScreen")
  }
}
