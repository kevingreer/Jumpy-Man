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
      musicButton.texture = onTexture
    }
    
    //SFX Button
    sfxButton = childNodeWithName("SFXButton") as! SKSpriteNode
    if NSUserDefaults.standardUserDefaults().boolForKey("sfxState"){
      sfxButton.texture = onTexture
    } else {
      sfxButton.texture = onTexture
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
    
    //Grass
    let grass = childNodeWithName("Grass") as! SKSpriteNode
    grass.texture = SKTexture(imageNamed: "Grass")
    let grassMovement = SKAction.moveByX(-33, y: 0, duration: 0.3)
    let grassReplacement = SKAction.moveByX(33, y: 0, duration: 0)
    grass.runAction(SKAction.repeatActionForever(SKAction.sequence([grassMovement, grassReplacement])))
    
    //Background
    let bg = childNodeWithName("Background") as! SKSpriteNode
    bg.texture = SKTexture(imageNamed: "Background")
    let bgMovement = SKAction.moveByX(-1024, y: 0, duration: 50)
    let bgReplacement = SKAction.moveByX(1024, y: 0, duration: 0)
    bg.runAction(SKAction.repeatActionForever(SKAction.sequence([bgMovement, bgReplacement])))
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch in touches as! Set<UITouch>{
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
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    for touch in touches as! Set<UITouch>{
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
