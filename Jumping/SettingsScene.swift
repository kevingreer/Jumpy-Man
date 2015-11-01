//
//  SettingsScene.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 1/25/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit
import UIKit

class SettingsScene: SKScene {
  
  // MARK: - Properties
  
  //Nodes
  var box: SKSpriteNode!
  var menuButton: SKSpriteNode!
  var musicButton: SKSpriteNode!
  var sfxButton: SKSpriteNode!
  var resetButton: SKSpriteNode!
  var currentHighScoreLabel: SKLabelNode!
  
  //Textures
  let onTexture = SKTexture(imageNamed: "OnButton")
  let offTexture = SKTexture(imageNamed: "OffButton")
  
  //Constants
  let ButtonInitialScale: CGFloat = 0.5
  let ButtonReducedScale: CGFloat = 0.47
  let ResetButtonInitialScale: CGFloat = 0.6
  let ResetButtonReducedScale: CGFloat = 0.57
  
  // MARK: - SKScene

  override func didMoveToView(view: SKView) {
    
    //Box
    box = childNodeWithName("Box") as! SKSpriteNode
    box.texture = SKTexture(imageNamed: "ScoreBox")
    
    //Menu Button
    menuButton = childNodeWithName("MenuButton") as! SKSpriteNode
    menuButton.texture = SKTexture(imageNamed: "MenuButton")
    
    //Music Button
    musicButton = childNodeWithName("MusicButton") as! SKSpriteNode
    if NSUserDefaults.standardUserDefaults().boolForKey("musicState"){
      musicButton.texture = onTexture
    } else {
      musicButton.texture = offTexture
    }
    
    //SFX Button
    sfxButton = childNodeWithName("SFXButton") as! SKSpriteNode
    if NSUserDefaults.standardUserDefaults().boolForKey("sfxState"){
      sfxButton.texture = onTexture
    } else {
      sfxButton.texture = offTexture
    }
    
    //Reset Button
    resetButton = childNodeWithName("ResetButton") as! SKSpriteNode
    resetButton.texture = SKTexture(imageNamed: "ResetButton")
    
    //High score label:
    let highScore = NSUserDefaults.standardUserDefaults().integerForKey("high score")
    currentHighScoreLabel = childNodeWithName("CurrentHighScoreLabel") as! SKLabelNode
    currentHighScoreLabel.text = "CURRENT HI-SCORE: \(highScore)"
    
    //Ground
    let ground = childNodeWithName("Ground") as! SKSpriteNode
    ground.texture = SKTexture(imageNamed: "Ground")
    ground.physicsBody = nil
    let groundMovement = SKAction.moveByX(-740, y: 0, duration: 2.0)
    let groundReplacement = SKAction.moveByX(740, y: 0, duration: 0)
    ground.runAction(SKAction.repeatActionForever(SKAction.sequence([groundMovement, groundReplacement])))
    
    //Background
    let bg = childNodeWithName("Background") as! SKSpriteNode
    bg.texture = SKTexture(imageNamed: "Background")
    let dx = bg.size.width/2
    let bgMovement = SKAction.moveByX(-dx, y: 0, duration: 50)
    let bgReplacement = SKAction.moveByX(dx, y: 0, duration: 0)
    bg.runAction(SKAction.repeatActionForever(SKAction.sequence([bgMovement, bgReplacement])))
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    
    for touch in touches {
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      if touchedNode == menuButton{
        menuButton.setScale(ButtonReducedScale)
      }
      else if touchedNode == musicButton{
        musicButton.setScale(ButtonReducedScale)
      }
      else if touchedNode == sfxButton{
        sfxButton.setScale(ButtonReducedScale)
      }
      else if touchedNode == resetButton{
        resetButton.setScale(ResetButtonReducedScale)
      }
    }
    
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    for touch in touches {
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      menuButton.setScale(ButtonInitialScale)
      musicButton.setScale(ButtonInitialScale)
      sfxButton.setScale(ButtonInitialScale)
      resetButton.setScale(ResetButtonInitialScale)
      
      if touchedNode == menuButton{
        presentMenuScene(false)
      }
        
      else if touchedNode == musicButton{
        let state = NSUserDefaults.standardUserDefaults().boolForKey("musicState")
        if (!state){
          musicButton.texture = onTexture
        }
        else{
          musicButton.texture = offTexture
        }
        NSUserDefaults.standardUserDefaults().setBool(!state, forKey: "musicState")
      }
      else if touchedNode == sfxButton{
        let state = NSUserDefaults.standardUserDefaults().boolForKey("sfxState")
        if (!state){
          sfxButton.texture = onTexture
        }
        else{
          print("swag")
          sfxButton.texture = offTexture
        }
        NSUserDefaults.standardUserDefaults().setBool(!state, forKey: "sfxState")
      }
      else if touchedNode == resetButton{
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "high score")
        currentHighScoreLabel.text = "CURRENT HI-SCORE: 0"
      }
    }
    
  }
  
  
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
    
  }
  
  
  
}
