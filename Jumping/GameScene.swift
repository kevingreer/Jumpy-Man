//
//  GameScene.swift
//  Jumping
//
//  Created by Kevin Greer on 12/22/14.
//  Copyright (c) 2014 Kevin Greer. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

struct PhysicsCategory {
  static let None  : UInt32 = 0x1
  static let All   : UInt32 = UInt32.max
  static let Man   : UInt32 = 0x1 << 1
  static let Barrel: UInt32 = 0x1 << 2
  static let Ground: UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate, AVAudioPlayerDelegate {
  
  //Bounds
  var screenWidth: CGFloat!
  var screenHeight: CGFloat!
  
  //Textures
  let idleTexture = SKTexture(imageNamed: "Mario")
  let runningTexture = SKTexture(imageNamed: "MarioRunning")
  let jumpingTexture = SKTexture(imageNamed: "MarioJumping")
  let groundTexture = SKTexture(imageNamed: "Ground")
  let backgroundTexture = SKTexture(imageNamed: "Background")
  let grassTexture = SKTexture(imageNamed: "Grass")
  
  //Nodes
  var hero: Hero!
  let scoreLabel =  SKLabelNode()
  let tapNode = SKLabelNode()
  var gameOverFlash: SKSpriteNode!
  let gameOverText = SKSpriteNode(imageNamed: "GameOver")
  var retryButton: SKSpriteNode!
  var menuButton: SKSpriteNode!
  var scoreBox: SKSpriteNode!
  let pauseNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(35, 35))
  var pauseFade: SKSpriteNode!
  var grass: SKSpriteNode!
  var endScoreLabel: SKLabelNode!
  var highScoreLabel: SKLabelNode!
  var ground: SKSpriteNode!
  var background: SKSpriteNode!
  
  //Audio players
  var backgroundMusicPlayer: AVAudioPlayer!
  var audioPlayer: AVAudioPlayer!
  
  //Misc
  var ihd = false //Is holding down: indicates user is holding down the screen
  let JumpTolerance: CGFloat = 20
  let ButtonInitialScale: CGFloat = 0.6
  let ButtonReducedScale: CGFloat = 0.57
  var barrelSpawnPoint: CGPoint!
  
  var GROUND_HEIGHT: CGFloat!
  var timer: NSTimer!
  var menuStall: NSTimer!
  var started = false
  let manCategory   : UInt32 = 0b1
  let barrelCategory: UInt32 = 0b10
  var gamePaused = false
  var centerPoint: CGPoint!
  var barrels: [Barrel] = []
  var timeInterval: NSTimeInterval = 2.0
  var score: Int = 0
  var run_anim: SKAction!
  var gameIsOver = false
  
  //Physics
  let GRAVITY: CGFloat = 20.0
  let BARREL_SPEED = 0.03
  
  //Sounds
  let jumpSound = SKAction.playSoundFileNamed("JumpSound.wav", waitForCompletion: false)
  let runSound = SKAction.playSoundFileNamed("RunningGrass.wav", waitForCompletion: true)
  
  override func didMoveToView(view: SKView) {
    
    //Set bounds
    screenWidth = self.frame.size.width
    screenHeight = self.frame.size.height
    GROUND_HEIGHT = screenHeight * 0.35
    centerPoint = CGPointMake(screenWidth/2, screenHeight/2)
    
    
    //Physics
    self.physicsWorld.gravity = CGVectorMake(0.0, -GRAVITY)
    self.physicsWorld.contactDelegate = self
    
    //Background
    background = childNodeWithName("Background") as! SKSpriteNode
    background.texture = backgroundTexture
    let bgMovement = SKAction.moveByX(-1024, y: 0, duration: 50)
    let bgReplacement = SKAction.moveByX(1024, y: 0, duration: 0)
    background.runAction(SKAction.repeatActionForever(SKAction.sequence([bgMovement, bgReplacement])))
    
    //Ground
    ground = childNodeWithName("Ground") as! SKSpriteNode
    ground.texture = groundTexture
    ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
    ground.physicsBody?.contactTestBitMask = PhysicsCategory.Man
    
    //Grass
    grass = childNodeWithName("Grass") as! SKSpriteNode
    grass.texture = grassTexture
    let grassMovement = SKAction.moveByX(-33, y: 0, duration: 0.3)
    let grassReplacement = SKAction.moveByX(33, y: 0, duration: 0)
    grass.runAction(SKAction.repeatActionForever(SKAction.sequence([grassMovement, grassReplacement])))
    
    //Hero
    let spawnPoint = childNodeWithName("SpawnPoint")!
    hero = Hero()
    hero.position = spawnPoint.position
    self.addChild(hero)
    spawnPoint.removeFromParent()
    
    //Setup score label
    scoreLabel.fontName = "04b_19"
    scoreLabel.text = "0"
    scoreLabel.fontSize = 80
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
    scoreLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.75)
    self.addChild(scoreLabel)
    
    //Setup tap label
    tapNode.fontName = "04b_19"
    tapNode.text = "TAP!"
    tapNode.fontSize = 80
    tapNode.color = UIColor.whiteColor()
    tapNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
    tapNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
    tapNode.position = centerPoint
    tapNode.name = "Tap Node"
    self.addChild(tapNode)
    
    /* Game over stuff */
    
    //Setup game over flash
    gameOverFlash = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(screenWidth, screenHeight))
    gameOverFlash.position = CGPointMake(screenWidth/2, screenHeight*4)
    gameOverFlash.zPosition = CGFloat(2.0)
    gameOverFlash.alpha = CGFloat(0.8)
    self.addChild(gameOverFlash)
    gameOverFlash.hidden = true
    gameOverFlash.name = "GameOverFlash"
    
    //Game over label
    gameOverText.position = CGPointMake(screenWidth/2, screenHeight*3+200)
    gameOverText.zPosition = CGFloat(2.0)
    gameOverText.hidden = true
    gameOverText.alpha = 0.0
    gameOverText.setScale(2)
    self.addChild(gameOverText)
    
    //Score Box
    scoreBox = childNodeWithName("ScoreBox") as! SKSpriteNode
//    scoreBox.hidden = true
    
    retryButton = childNodeWithName("RetryButton") as! SKSpriteNode
//    retryButton.hidden = true
    
    menuButton = childNodeWithName("MenuButton") as! SKSpriteNode
    
    endScoreLabel = scoreBox.childNodeWithName("ScoreLabel") as! SKLabelNode
    
    highScoreLabel = scoreBox.childNodeWithName("HighScoreLabel") as! SKLabelNode
    
    if (NSUserDefaults.standardUserDefaults().boolForKey("musicState")){
      playBackgroundMusic("Jumper.mp3")
    }
    if (NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
      playRunningSound("RunningGrass.wav")
    }
    
    let point = childNodeWithName("BarrelSpawnPoint")!
    barrelSpawnPoint = point.position
    point.removeFromParent()
    
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    ihd = true
    
    for touch: AnyObject in touches as! Set<UITouch>{
      
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      println(touchedNode.name)
      if touchedNode == retryButton{
        retryButton.setScale(ButtonReducedScale)
      }
      else if touchedNode == menuButton{
        menuButton.setScale(ButtonReducedScale)
      }
      if !started{
        tapNode.removeFromParent()
        started = true
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
      }
      if heroCanJump() && !gamePaused{
        jump()
      }
    }
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    
    ihd = false
    
    for touch in touches as! Set<UITouch>{
      
      retryButton.setScale(ButtonInitialScale)
      menuButton.setScale(ButtonInitialScale)
      let touchedNode = nodeAtPoint(touch.locationInNode(self))
      if touchedNode == retryButton{
        presentGameScene()
      }
      else if touchedNode == menuButton{
        presentMenuScene(true)
      }
    }
    
  }
  
  override func update(currentTime: CFTimeInterval) {
    
    for b in barrels{
      if manClearedBarrel(b){
        score++
        scoreLabel.text = "\(Int(score))"
      }
      b.prevPosition = b.position
    }
    
    if hero.isJumping {
      hero.manageJumpChange()
      if ihd {
        hero.applyForce()
      }
    }
  }
  
  // MARK: - Movement
  
  ///Functions that must be done while the Character is jumping
  func jump(){
    if (NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
      self.runAction(jumpSound)
      audioPlayer.pause()
    }
    hero.jump()
  }
  
  ///Functions that must be done when the Character lands
  func land(){
    hero.land()
    if (!gameIsOver && NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
      audioPlayer.play()
    }
    
  }
  
  ///Creates a Barrel offscreen and sets it in motion
  func spawnBarrel() {
    let barrel = Barrel(spawnPoint: barrelSpawnPoint)
    
    self.addChild(barrel)
    
    barrels.append(barrel)
  }
  
  ///="The Character has cleared the barrel this frame (he was not clear the previous frame)"
  func manClearedBarrel(b: Barrel) -> Bool{
    var beginOfManX = hero.position.x - hero.size.width/2
    
    var endOfBarrelX = b.position.x + b.size.width/2    //current
    var prevEndOfBarrelX = b.prevPosition.x + b.size.width/2 //previous
    if endOfBarrelX < beginOfManX && !(prevEndOfBarrelX < beginOfManX){
      return true
    }
    return false
  }
  
  func heroCanJump() -> Bool {
    let dy = (hero.position.y - hero.size.height/2) - (ground.position.y + ground.size.height/2)
    return abs(dy) < JumpTolerance
  }
  
  // MARK: - NSTimer
  
  ///Spawns a Barrel and alters the time interval of the timer.
  func fireTimer(sender: NSTimer) {
    let MINIMUM = 0.63
    let VARIANCE = 0.25
    let breatherChance: CGFloat = 0.05  // a breather gives the player a longer space between Barrels (1 second)
    spawnBarrel()
    let breatherResult = CGFloat(drand48())
    if (breatherResult<breatherChance){
      timeInterval = 1
    }
    else{
      timeInterval = NSTimeInterval(CGFloat(drand48() * VARIANCE + MINIMUM))
    }
    timer.fireDate = timer.fireDate.dateByAddingTimeInterval(timeInterval)
  }
  
  // MARK: - SKPhysicsContactDelegate
  
  func didBeginContact(contact: SKPhysicsContact){
    
    var one: SKPhysicsBody = contact.bodyA
    var two: SKPhysicsBody = contact.bodyB
    
    if ( (one.categoryBitMask == PhysicsCategory.Barrel || two.categoryBitMask == PhysicsCategory.Barrel) &&
      (one.categoryBitMask == PhysicsCategory.Man || two.categoryBitMask == PhysicsCategory.Man) ){
        gameOver()
    }
    
    if ( (one.categoryBitMask == PhysicsCategory.Ground || two.categoryBitMask == PhysicsCategory.Ground) &&
      (one.categoryBitMask == PhysicsCategory.Man || two.categoryBitMask == PhysicsCategory.Man) ){
        land();
    }
  }
  
  // MARK: - Game Interuptions
  
  ///Functions to be run when the game is over
  func gameOver(){
    background.removeAllActions()
    if (NSUserDefaults.standardUserDefaults().boolForKey("musicState")){
      backgroundMusicPlayer.stop()
    }
    
    if (!gameIsOver && NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
      self.runAction(SKAction.playSoundFileNamed("CartoonPunch.wav", waitForCompletion: false))
      audioPlayer.stop()
    }
    
    pause()
    pauseNode.removeFromParent()
    scoreLabel.removeFromParent()
    gameOverFlash.position = centerPoint
    gameOverFlash.hidden = false
    gameOverFlash.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.5))
    gameOverText.position = CGPointMake(screenWidth/2, screenHeight * 0.75 + 50)
    gameOverText.hidden = false
    gameOverText.runAction(SKAction.fadeInWithDuration(0.5))
//    scoreBox.hidden = false
//    retryButton.hidden = false
//    menuButton.hidden = false
    scoreBox.runAction(SKAction.moveTo(CGPointMake(screenWidth/2, screenHeight * 0.575), duration: 0.4))
    endScoreLabel.text = "SCORE  \(score)"
    
    let highScore = NSUserDefaults.standardUserDefaults().integerForKey("high score")
    if score > highScore{
      NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "high score")
    }
    highScoreLabel.text = "BEST  \(highScore)"
    retryButton.runAction(SKAction.moveTo(CGPointMake(screenWidth/2, screenHeight * 0.3), duration: 0.6))
    menuButton.runAction(SKAction.moveTo(CGPointMake(screenWidth/2, screenHeight * 0.2), duration: 0.7))
    timer.invalidate()
    gameIsOver = true
    
  }
  
  ///Stops the Character, Barrels, and grass from moving and stops the timer.
  func pause(){
    gamePaused = true
    for b in barrels{
      b.paused = true
      b.physicsBody?.dynamic = false
    }
    hero.paused = true
    grass.paused = true
    //man.physicsBody?.dynamic = false
    if started{
      timer.invalidate()
    }
    
  }
  
  ///Undoes the pause() method
  func unpause(){
    gamePaused = false
    for b in barrels{
      b.paused = false
      b.physicsBody?.dynamic = true
    }
    hero.paused = false
    grass.paused = false
    //man.physicsBody?.dynamic = true
    if started{
      timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
    }
    
    pauseFade.hidden = true
  }
  
  // MARK: - AVAudioPlayer
  
  func playRunningSound(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
      filename, withExtension: nil)
    if (url == nil) {
      println("Could not find file: \(filename)")
      return
    }
    
    var error: NSError? = nil
    audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
    if audioPlayer == nil {
      println("Could not create audio player: \(error!)")
      return
    }
    
    audioPlayer.numberOfLoops = -1
    audioPlayer.prepareToPlay()
    audioPlayer.play()
  }
  
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
    backgroundMusicPlayer.play()
    backgroundMusicPlayer.volume = 0.5
  }
}
