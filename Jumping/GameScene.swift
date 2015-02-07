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
    static let None  : UInt32 = 0
    static let All   : UInt32 = UInt32.max
    static let Man   : UInt32 = 0b1
    static let Barrel: UInt32 = 0b10
    static let Ground: UInt32 = 0b11
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

    //Nodes
    let man = Man(texture: SKTexture(imageNamed: "ManRunning1"), color: UIColor.whiteColor(), size: SKTexture(imageNamed: "ManRunning1").size())
    let scoreLabel = SKLabelNode()
    let scoreOutline = SKLabelNode()
    let tapNode = SKLabelNode()
    var gameOverFlash: SKSpriteNode!
    let gameOverMenu = SKSpriteNode(color: UIColor.darkGrayColor(), size: CGSizeMake(200, 300))
    let gameOverText = SKSpriteNode(imageNamed: "GameOver")
    let retryButton = SKSpriteNode(imageNamed: "RetryButton")
    let menuButton = SKSpriteNode(imageNamed: "MenuButton")
    let scoreBox = SKSpriteNode(imageNamed: "ScoreBox")
    let pauseNode = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(35, 35))
    var pauseFade: SKSpriteNode!
    let grass = SKSpriteNode(imageNamed: "Grass")
    let endScoreLabel = SKLabelNode()
    let highScoreLabel = SKLabelNode()
    let ground = SKSpriteNode(imageNamed: "Ground")
    let background = SKSpriteNode(imageNamed: "Background")
    
    //Audio players
    var backgroundMusicPlayer: AVAudioPlayer!
    var audioPlayer: AVAudioPlayer!
    
    //Misc
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
    var jumping = false
    var gameIsOver = false
    
    //Physics
    let GRAVITY: CGFloat = 15.0
    let IMPULSE: CGFloat = 60.0
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
        self.backgroundColor = UIColor.blackColor()
        background.setScale(2)
        background.position = CGPointMake(background.size.width/2, screenHeight - background.size.height/2)
        let bgMovement = SKAction.moveByX(-1024, y: 0, duration: 50)
        let bgReplacement = SKAction.moveByX(1024, y: 0, duration: 0)
        background.runAction(SKAction.repeatActionForever(SKAction.sequence([bgMovement, bgReplacement])))
        background.zPosition = CGFloat.min
        background.runAction(SKAction.repeatActionForever(SKAction.moveByX(-2, y: 0, duration: 1)))
        self.addChild(background)
        
        //Ground
        ground.position = CGPointMake(screenWidth/2, GROUND_HEIGHT/2)
        ground.size = CGSizeMake(screenWidth, GROUND_HEIGHT)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Man
        ground.name = "Ground"
        ground.physicsBody?.restitution = 0
        ground.zPosition = 0.2
        self.addChild(ground)
        
        //Grass
        grass.position = CGPointMake(screenWidth/2, GROUND_HEIGHT+grass.size.height/2)
        grass.zPosition = 0.1
        self.addChild(grass)
        let grassMovement = SKAction.moveByX(-33, y: 0, duration: 0.3)
        let grassReplacement = SKAction.moveByX(33, y: 0, duration: 0)
        grass.runAction(SKAction.repeatActionForever(SKAction.sequence([grassMovement, grassReplacement])))
        
        //Man
        man.position = CGPointMake(screenWidth * 0.40, GROUND_HEIGHT+man.size.height/2)
        self.addChild(man)
        
        //Setup score label
        scoreLabel.fontName = "04b_19"
        scoreLabel.text = "0"
        scoreLabel.fontSize = 40
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreLabel.position = CGPoint(x: screenWidth/2, y: screenHeight * 0.75)
        
        
        scoreOutline.fontName = "04b_19"
        scoreOutline.text = "0"
        scoreOutline.fontSize = 45
        scoreOutline.fontColor = UIColor.blackColor()
        scoreOutline.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreOutline.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreOutline.position = CGPoint(x: screenWidth/2 + 1, y: screenHeight * 0.75-1)
//        scoreOutline.zPosition = scoreLabel.zPosition - 0.1
        self.addChild(scoreOutline)
        self.addChild(scoreLabel)
        
        //Setup tap label
        tapNode.fontName = "04b_19"
        tapNode.text = "TAP!"
        tapNode.fontSize = 30
        tapNode.color = UIColor.whiteColor()
        tapNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        tapNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        tapNode.position = centerPoint
        tapNode.name = "Tap Node"
        self.addChild(tapNode)
        
        //Setup game over flash
        gameOverFlash = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(screenWidth, screenHeight))
        gameOverFlash.position = CGPointMake(screenWidth/2, screenHeight*4)
        gameOverFlash.zPosition = CGFloat(1.0)
        gameOverFlash.alpha = CGFloat(0.8)
        self.addChild(gameOverFlash)
        gameOverFlash.hidden = true
        
        //Game over nodes
        gameOverText.position = CGPointMake(screenWidth/2, screenHeight*3)
        gameOverText.zPosition = CGFloat(2.0)
        gameOverText.hidden = true
        gameOverText.alpha = 0.0
        self.addChild(gameOverText)
        
        scoreBox.position = CGPointMake(screenWidth/2, -screenHeight*2)
        scoreBox.zPosition = CGFloat(2.0)
        scoreBox.hidden = true
        self.addChild(scoreBox)
        
        retryButton.position = CGPointMake(screenWidth/2, -screenHeight*2)
        retryButton.zPosition = CGFloat(2.0)
        retryButton.hidden = true
        retryButton.setScale(0.50)
        self.addChild(retryButton)
        
        menuButton.position = CGPointMake(screenWidth/2, -screenHeight*2)
        menuButton.zPosition = CGFloat(2.0)
        menuButton.hidden = true
        menuButton.setScale(0.50)
        self.addChild(menuButton)
        
        endScoreLabel.fontName = "04b_19"
        endScoreLabel.text = "endScoreLabel"
        endScoreLabel.fontSize = 30
        endScoreLabel.color = UIColor.whiteColor()
        endScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        endScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreBox.addChild(endScoreLabel)
        endScoreLabel.position = CGPointMake(0, scoreBox.size.height/5)
        
        highScoreLabel.fontName = "04b_19"
        highScoreLabel.text = "highScoreLabel"
        highScoreLabel.fontSize = 30
        highScoreLabel.color = UIColor.whiteColor()
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        highScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreBox.addChild(highScoreLabel)
        highScoreLabel.position = CGPointMake(0, -scoreBox.size.height/5)

        if (NSUserDefaults.standardUserDefaults().boolForKey("musicState")){
            playBackgroundMusic("Jumper.mp3")
        }
        if (NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
            playRunningSound("RunningGrass.wav")
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            if touchedNode == retryButton{
                retryButton.setScale(0.45)
            }
            else if touchedNode == menuButton{
                menuButton.setScale(0.45)
            }
            if !started{
                tapNode.removeFromParent()
                started = true
                timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
            }
            if !jumping && !gamePaused{
                jump()
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            
            retryButton.setScale(0.5)
            menuButton.setScale(0.5)
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
                scoreOutline.text = "\(Int(score))"
            }
            b.prevPosition = b.position
        }
        
    }
    
    // MARK: - Movement
    
    ///Functions that must be done while the Character is jumping
    func jump(){
        if (NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
            self.runAction(jumpSound)
            audioPlayer.pause()
        }
        jumping = true
        man.jump(IMPULSE)
    }
    
    ///Functions that must be done when the Character lands
    func land(){
        jumping = false
        man.run()
        if (!gameIsOver && NSUserDefaults.standardUserDefaults().boolForKey("sfxState")){
            audioPlayer.play()
        }

    }
    
    ///Creates a Barrel offscreen and sets it in motion
    func spawnBarrel() {
        let sprite = Barrel(imageNamed:"Barrel")
        
        sprite.setScale(0.12)
        sprite.position = CGPointMake(screenWidth-sprite.size.width, GROUND_HEIGHT)
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:0.5)
        
        sprite.runAction(SKAction.repeatActionForever(action))
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height/2)
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Barrel
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Man
        sprite.physicsBody?.usesPreciseCollisionDetection = true
        let moveBarrel = SKAction.moveByX(-10, y: 0.0, duration: BARREL_SPEED)
        sprite.runAction(SKAction.repeatActionForever(moveBarrel))
        sprite.prevPosition = sprite.position
        
        self.addChild(sprite)
        
        barrels.append(sprite)
    }
    
    ///="The Character has cleared the barrel this frame (he was not clear the previous frame)"
    func manClearedBarrel(b: Barrel) -> Bool{
        var beginOfManX = man.position.x - man.size.width/2
        
        var endOfBarrelX = b.position.x + b.size.width/2    //current
        var prevEndOfBarrelX = b.prevPosition.x + b.size.width/2 //previous
        if endOfBarrelX < beginOfManX && !(prevEndOfBarrelX < beginOfManX){
            return true
        }
        return false
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
        scoreOutline.removeFromParent()
        gameOverFlash.position = centerPoint
        gameOverFlash.hidden = false
        gameOverFlash.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.5))
        gameOverText.position = CGPointMake(screenWidth/2, screenHeight * 0.75)
        gameOverText.hidden = false
        gameOverText.runAction(SKAction.fadeInWithDuration(0.5))
        scoreBox.hidden = false
        retryButton.hidden = false
        menuButton.hidden = false
        scoreBox.runAction(SKAction.moveTo(CGPointMake(screenWidth/2, screenHeight * 0.575), duration: 0.4))
        endScoreLabel.text = "SCORE  \(score)"
        
        let highScore = NSUserDefaults.standardUserDefaults().integerForKey("high score")
        if score > highScore{
            NSUserDefaults.standardUserDefaults().setInteger(score, forKey: "high score")
        }
        highScoreLabel.text = "BEST  \(highScore)"
        retryButton.runAction(SKAction.moveTo(CGPointMake(screenWidth/2, screenHeight * 0.4), duration: 0.6))
        menuButton.runAction(SKAction.moveTo(CGPointMake(screenWidth/2, screenHeight * 0.3), duration: 0.7))
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
        man.paused = true
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
        man.paused = false
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
