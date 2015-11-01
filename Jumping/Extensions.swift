//
//  Extensions.swift
//  Jumping
//
//  Created by Kevin Greer on 1/11/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

enum Scenes {
  case Game, Menu, Settings, Store
  
  var string: String{
    switch self {
    case Game:
      return "GameScene"
    case Menu:
      return "MenuScene"
    case Settings:
      return "SettingsScene"
    case Store:
      return "StoreScene"
    }
  }
  
}

extension SKNode {
  
  class func unarchiveScene (sceneType: Scenes) -> SKNode? {
    if let path = NSBundle.mainBundle().pathForResource(sceneType.string, ofType: "sks") {
      let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
      let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
      
      archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
      let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! SKNode
      
      archiver.finishDecoding()
      return scene
      
    } else {
      return nil
    }
  }
}

extension SKScene{
  
  /** 
      Presents the given SKScene from the current SKScene
   
      - Parameter scene: The scene to present
      - Parameter animated: Whether or not the transition between the current 
         scene and `scene` should be animated
   */
  func presentScene(scene: SKScene, animated: Bool) {
    // Configure the view.
    let skView = self.view!
    // skView.showsFPS = true
    // skView.showsNodeCount = true
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = true
    
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = .AspectFill
    
    if animated {
      let transition = SKTransition.fadeWithColor(UIColor.blackColor(), duration: 1.0)
      skView.presentScene(scene, transition: transition)
    } else {
      skView.presentScene(scene)
    }

  }
  
  ///Shortcut for presenting a GameScene from another SKScene
  func presentGameScene(){
    if let scene = GameScene.unarchiveScene(.Game) as? GameScene {
      presentScene(scene, animated: true)
    }
  }
  
  ///Shortcut for presenting a MenuScene from another SKScene
  func presentMenuScene(animated: Bool){
    
    if let scene = MenuScene.unarchiveScene(.Menu) as? MenuScene {
      presentScene(scene, animated: true)
    }
  }
  
  ///Shortcut for presenting a SettingsScene from another SKScene
  func presentSettingsScene(){
    if let scene = SettingsScene.unarchiveScene(.Settings) as? SettingsScene {
      presentScene(scene, animated: false)
    }
  }
  
  ///Shortcut for presenting a SettingsScene from another SKScene
  func presentStoreScene(){
    if let scene = StoreScene.unarchiveScene(.Store) as? StoreScene {
      presentScene(scene, animated: false)
    }
  }
  
}

extension SKSpriteNode{
  func stop(){
    self.physicsBody?.velocity = CGVectorMake(0, 0)
  }
}