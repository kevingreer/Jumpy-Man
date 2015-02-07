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
    let title = SKSpriteNode(imageNamed: "Title")
    let playButton = SKSpriteNode(imageNamed: "PlayButton")
    let settingsButton = SKSpriteNode(imageNamed: "SettingsButton")
    var timer: NSTimer!
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.gravity = CGVectorMake(0.0, -2)
        
        //Set Bounds
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        let GROUND_HEIGHT = screenHeight * 0.35
        
        //Stopper
        let stopper = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(screenWidth, 0.0001))
        stopper.position = CGPointMake(screenWidth/2, screenHeight * 0.6)
        stopper.physicsBody = SKPhysicsBody(rectangleOfSize: stopper.size)
        stopper.physicsBody?.dynamic = false
        self.addChild(stopper)
        
        //Title
        title.setScale(0.75)
        title.physicsBody?.restitution = 1.0
        title.position = CGPointMake(screenWidth/2, screenHeight * 0.63)
        title.physicsBody = SKPhysicsBody(rectangleOfSize: title.size)
        self.addChild(title)
        
        //Play Button
        playButton.position = CGPointMake(screenWidth/2, screenHeight * 0.45)
        playButton.setScale(0.50)
        playButton.zPosition = 1.0
        self.addChild(playButton)
        
        //Settings Button
        settingsButton.position = CGPointMake(screenWidth/2, screenHeight * 0.35)
        settingsButton.setScale(0.50)
        settingsButton.zPosition = 1.0
        self.addChild(settingsButton)
        
        //Ground
        let ground = SKSpriteNode(imageNamed: "Ground")
        ground.position = CGPointMake(screenWidth/2, GROUND_HEIGHT/2)
        ground.size = CGSizeMake(screenWidth, GROUND_HEIGHT)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.dynamic = false
        ground.physicsBody?.allowsRotation = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Man
        ground.name = "Ground"
        self.addChild(ground)
        
        //Grass
        let grass = SKSpriteNode(imageNamed: "Grass")
        grass.yScale = 1
        grass.position = CGPointMake(screenWidth/2, GROUND_HEIGHT+grass.size.height/2)
        grass.zPosition = 0.1
        let grassMovement = SKAction.moveByX(-33, y: 0, duration: 0.5)
        let grassReplacement = SKAction.moveByX(33, y: 0, duration: 0)
        grass.runAction(SKAction.repeatActionForever(SKAction.sequence([grassMovement, grassReplacement])))
        self.addChild(grass)
        
        //Background
        let background = SKSpriteNode(imageNamed: "Background")
        background.setScale(2)
        background.position = CGPointMake(background.size.width/2, screenHeight - background.size.height/2)
        let bgMovement = SKAction.moveByX(-1024, y: 0, duration: 100)
        let bgReplacement = SKAction.moveByX(1024, y: 0, duration: 0)
        background.runAction(SKAction.repeatActionForever(SKAction.sequence([bgMovement, bgReplacement])))
        background.zPosition = -1000
        self.addChild(background)
    
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "fireTimer:", userInfo: nil, repeats: true)
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("musicState")){
            playBackgroundMusic("Jumper.mp3")
        }

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches{
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            
            if touchedNode == playButton{
                playButton.setScale(0.47)
            }
            else if touchedNode == settingsButton{
                settingsButton.setScale(0.47)
            }

        }
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches{
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            
            if touchedNode != playButton{
                playButton.setScale(0.5)
            }
            if touchedNode != settingsButton{
                settingsButton.setScale(0.5)
            }
            
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches{
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            playButton.setScale(0.50)
            settingsButton.setScale(0.50)
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
