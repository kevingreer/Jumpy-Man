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
    let box = SKSpriteNode(imageNamed: "ScoreBox")
    let menuButton = SKSpriteNode(imageNamed: "MenuButton")
    let bgLabel = SKLabelNode(text: "MUSIC")
    let sfxLabel = SKLabelNode(text: "SOUND EFFECTS")
    let resetScoreLabel = SKLabelNode(text: "RESET HISCORE")
    let bgNode = SKSpriteNode(imageNamed: "OnButton")
    let sfxNode = SKSpriteNode(imageNamed: "OnButton")
    let resetButton = SKSpriteNode(imageNamed: "ResetButton")
    
    //Textures
    let onTexture = SKTexture(imageNamed: "OnButton")
    let offTexture = SKTexture(imageNamed: "OffButton")
    
    
    override func didMoveToView(view: SKView) {
        
        //Bounds
        let screenWidth = self.frame.size.width
        let screenHeight = self.frame.size.height
        let GROUND_HEIGHT = screenHeight * 0.35
        
        //Box
        box.position = CGPointMake(screenWidth/2, screenHeight/2)
        box.size = CGSizeMake(screenHeight*0.75*0.6, screenHeight*0.75)
        box.zPosition = 1000
        self.addChild(box)
        
        //Box contents
        menuButton.setScale(0.5)
        menuButton.zPosition = 1001
        menuButton.position = CGPointMake(screenWidth/2, box.position.y + box.size.height/2 + menuButton.size.height/2 + 10)
        self.addChild(menuButton)
        
        bgLabel.fontName = "04b_19"
        bgLabel.fontSize = 40
        bgLabel.color = UIColor.whiteColor()
        bgLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        bgLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        bgLabel.position = CGPoint(x: 0, y: box.size.height/2 - box.size.height/7)
        box.addChild(bgLabel)
        
        bgNode.position = CGPoint(x: 0, y: box.size.height/2 - 2*box.size.height/7)
        bgNode.setScale(0.4)
        if !NSUserDefaults.standardUserDefaults().boolForKey("musicState"){
            bgNode.texture = offTexture
        }
        box.addChild(bgNode)
        
        sfxLabel.fontName = "04b_19"
        sfxLabel.fontSize = 40
        sfxLabel.color = UIColor.whiteColor()
        sfxLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        sfxLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        sfxLabel.position = CGPoint(x: 0, y: box.size.height/2 - 3*box.size.height/7)
        box.addChild(sfxLabel)
        
        sfxNode.position = CGPoint(x: 0, y: box.size.height/2 - 4*box.size.height/7)
        sfxNode.setScale(0.4)
        if !NSUserDefaults.standardUserDefaults().boolForKey("sfxState"){
            sfxNode.texture = offTexture
        }
        box.addChild(sfxNode)
        
        resetScoreLabel.fontName = "04b_19"
        resetScoreLabel.fontSize = 40
        resetScoreLabel.color = UIColor.whiteColor()
        resetScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        resetScoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        resetScoreLabel.position = CGPoint(x: 0, y: box.size.height/2 - 5*box.size.height/7)
        box.addChild(resetScoreLabel)
        
        resetButton.position = CGPoint(x: 0, y: box.size.height/2 - 6*box.size.height/7)
        resetButton.setScale(0.5)
        box.addChild(resetButton)
        
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
        let grassMovement = SKAction.moveByX(-33, y: 0, duration: 1)
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
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in touches{
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            if touchedNode == menuButton{
                menuButton.setScale(0.47)
            }
            else if touchedNode == bgNode{
                bgNode.setScale(0.37)
            }
            else if touchedNode == sfxNode{
                sfxNode.setScale(0.37)
            }
            else if touchedNode == resetButton{
                resetButton.setScale(0.47)
            }
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches{
            let touchedNode = nodeAtPoint(touch.locationInNode(self))
            menuButton.setScale(0.5)
            bgNode.setScale(0.4)
            sfxNode.setScale(0.4)
            resetButton.setScale(0.5)
            if touchedNode == menuButton{
                presentMenuScene(false)
            }
            else if touchedNode == bgNode{
                let state = NSUserDefaults.standardUserDefaults().boolForKey("musicState")
                if (!state){
                    bgNode.texture = onTexture
                }
                else{
                    bgNode.texture = offTexture
                }
                NSUserDefaults.standardUserDefaults().setBool(!state, forKey: "musicState")
            }
            else if touchedNode == sfxNode{
                let state = NSUserDefaults.standardUserDefaults().boolForKey("sfxState")
                if (!state){
                    sfxNode.texture = onTexture
                }
                else{
                    sfxNode.texture = offTexture
                }
                NSUserDefaults.standardUserDefaults().setBool(!state, forKey: "sfxState")
            }
            else if touchedNode == resetButton{
                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "high score")
            }
        }

    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    


}
