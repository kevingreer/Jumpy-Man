//
//  Extensions.swift
//  Jumping
//
//  Created by Kevin Greer on 1/11/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

extension SKNode {
    class func unarchiveGameSceneFromFile (file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
  
  class func unarchiveMenuSceneFromFile (file : NSString) -> SKNode? {
    if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
      var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
      var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
      
      archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
      let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! MenuScene
      archiver.finishDecoding()
      return scene
    } else {
      return nil
    }
  }
}

extension SKScene{
  
    ///Shortcut for presenting a GameScene from another SKScene
    func presentGameScene(){
        
        if let scene = GameScene.unarchiveGameSceneFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view!
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
          
            let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.0)
            skView.presentScene(scene, transition: transition)
        }
      

        
//        let scene = GameScene(size: self.size)
//        let skView = self.view!
////        skView.showsFPS = true
////        skView.showsNodeCount = true
//        scene.scaleMode = .AspectFill
//        skView.presentScene(scene, transition: transition)
    }
    
    ///Shortcut for presenting a MenuScene from another SKScene
    func presentMenuScene(trans: Bool){
        let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.0)
        
        let scene = MenuScene(size: self.size)
        let skView = self.view!
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        scene.scaleMode = .AspectFill
        if (trans){
            skView.presentScene(scene, transition: transition)
        }
        else{
            skView.presentScene(scene)
        }
    }
    
    ///Shortcut for presenting a SettingsScene from another SKScene
    func presentSettingsScene(){
        let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.0)
        
        let scene = SettingsScene(size: self.size)
        let skView = self.view!
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
}

extension SKSpriteNode{
    func stop(){
        self.physicsBody?.velocity = CGVectorMake(0, 0)
    }
}