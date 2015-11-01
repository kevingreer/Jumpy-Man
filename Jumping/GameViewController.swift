//
//  GameViewController.swift
//  Jumping
//
//  Created by Kevin Greer on 12/22/14.
//  Copyright (c) 2014 Kevin Greer. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

class GameViewController: UIViewController {
  
  // MARK: - Properties
  
  var adView: ADBannerView!
  var bannerIsVisible = false
  
  // MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let scene = MenuScene.unarchiveScene(.Menu) as? MenuScene {
      //      if let scene = StoreScene.unarchiveStoreSceneFromFile("StoreScene") as? StoreScene {
      // Configure the view.
      let skView = self.view as! SKView
      //        skView.showsFPS = true
      //        skView.showsNodeCount = true
      
      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true
      
      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .AspectFill
      
      skView.presentScene(scene)
    }
    
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    adView = ADBannerView(frame: CGRectMake(0, self.view.frame.size.height, 320, 50))
    adView.delegate = self
    self.view.addSubview(adView)
  }
  
  override func shouldAutorotate() -> Bool {
    return false
  }
  
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return UIInterfaceOrientationMask.AllButUpsideDown
    } else {
      return UIInterfaceOrientationMask.All
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
}

// MARK: - ADBannerViewDelegate

extension GameViewController: ADBannerViewDelegate {
  func bannerViewDidLoadAd(banner: ADBannerView!) {
    if !bannerIsVisible {
      if adView.superview == nil {
        self.view.addSubview(adView)
      }
      
      UIView.beginAnimations("animateAdBannerOn", context: nil)
      banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height)
      UIView.commitAnimations()
      
      bannerIsVisible = true
    }
  }
  
  func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
    print("Failed to retrieve ad")
    
    if bannerIsVisible {
      UIView.beginAnimations("animateAdBannerOff", context: nil)
      banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height)
      UIView.commitAnimations()
      bannerIsVisible = false
    }
  }
  
  func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
    let skView = self.view as! SKView
    if let gameScene = skView.scene as? GameScene {
      gameScene.pause()
    }
    return true
  }
  
  func bannerViewActionDidFinish(banner: ADBannerView!) {
    let skView = self.view as! SKView
    if let gameScene = skView.scene as? GameScene {
      gameScene.unpause()
    }
  }
}
