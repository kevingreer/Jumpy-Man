//
//  MenuScene.swift
//  Jumping
//
//  Created by Kevin Greer on 1/8/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene{
  
  var backgroundMusicPlayer: AVAudioPlayer!
  var title: SKSpriteNode!
  var playButton: SKSpriteNode!
  var settingsButton: SKSpriteNode!
  var timer: NSTimer!
  
  let ButtonInitialScale: CGFloat = 0.6
  let ButtonReducedScale: CGFloat = 0.57
  
  override func didMoveToView(view: SKView) {
    self.physicsWorld.gravity = CGVectorMake(0.0, -2)
    
    //Set Bounds
    let screenWidth = self.frame.size.width
    let screenHeight = self.frame.size.height
    let GROUND_HEIGHT = screenHeight * 0.35
    
    //Stopper
    let stopperRect = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height*0.6, frame.size.width, 1)
    let stopper = SKNode()
    stopper.physicsBody = SKPhysicsBody(edgeLoopFromRect: stopperRect)
    self.addChild(stopper)
    
    //Title
    title = childNodeWithName("Title") as! SKSpriteNode
    title.texture = SKTexture(imageNamed: "Title")
    
    //Play Button
    playButton = childNodeWithName("PlayButton") as! SKSpriteNode
    playButton.texture = SKTexture(imageNamed: "PlayButton")
    
    //Settings Button
    settingsButton = childNodeWithName("SettingsButton") as! SKSpriteNode
    settingsButton.texture = SKTexture(imageNamed: "SettingsButton")
    
    //Ground
    let ground = childNodeWithName("ground") as! SKSpriteNode
    ground.texture = SKTexture(imageNamed: "Ground")
    
    //Grass
    let grass = childNodeWithName("grass") as! SKSpriteNode
    grass.texture = SKTexture(imageNamed: "Grass")
    let grassMovement = SKAction.moveByX(-33, y: 0, duration: 0.3)
    let grassReplacement = SKAction.moveByX(33, y: 0, duration: 0)
    grass.runAction(SKAction.repeatActionForever(SKAction.sequence([grassMovement, grassReplacement])))
    
    //Background
    let bg = childNodeWithName("background") as! SKSpriteNode
    bg.texture = SKTexture(imageNamed: "Background")
    let bgMovement = SKAction.moveByX(-1024, y: 0, duration: 50)
    let bgReplacement = SKAction.moveByX(1024, y: 0, duration: 0)
    bg.runAction(SKAction.repeatActionForever(SKAction.sequence([bgMovement, bgReplacement])))
  
    
    if (NSUserDefaults.standardUserDefaults().boolForKey("musicState")){
      playBackgroundMusic("Jumper.mp3")
    }
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    for touch in touches as! Set<UITouch>{
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      
      if touchedNode == playButton{
        playButton.setScale(ButtonReducedScale)
      }
      else if touchedNode == settingsButton{
        settingsButton.setScale(ButtonReducedScale)
      }
      
    }
    
  }
  
  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    for touch in touches as! Set<UITouch>{
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      
      if touchedNode != playButton{
        playButton.setScale(ButtonInitialScale)
      }
      if touchedNode != settingsButton{
        settingsButton.setScale(ButtonInitialScale)
      }
      
    }
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    for touch in touches as! Set<UITouch>{
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      playButton.setScale(ButtonInitialScale)
      settingsButton.setScale(ButtonInitialScale)
      if touchedNode == playButton{
        //Present the GameScene
        presentGameScene()
        if NSUserDefaults.standardUserDefaults().boolForKey("musicState"){
          backgroundMusicPlayer.stop()
        }
      }
        
      else if touchedNode == settingsButton{
        //Present the SettingsScene
        if NSUserDefaults.standardUserDefaults().boolForKey("musicState"){
          backgroundMusicPlayer.pause()
        }
        presentSettingsScene()
      }
      
    }
  }
  
  override func update(currentTime: CFTimeInterval) {}
  
  // MARK: - NSTimer
  
  func fireTimer(sender: NSTimer) {
    title.physicsBody?.applyImpulse(CGVectorMake(0, 100))
  }
  
  // MARK: - AVAudioPlayer
  
  func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
      filename, withExtension: nil)
    if (url == nil) {
      println("Could not find file: \(filename)")
      return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
      println("Could not create audio player: \(error!)")
      return
    }
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    if (NSUserDefaults.standardUserDefaults().boolForKey("musicState")){
      backgroundMusicPlayer.play()
    }
    backgroundMusicPlayer.volume = 0.5
  }
}
