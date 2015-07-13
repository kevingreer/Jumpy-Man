//
//  GameCenterManager.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 7/11/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import Foundation
import GameKit

public class GameCenterManager: NSObject {
  
  static let sharedInstance = GameCenterManager()
  
  var gameCenterAvailable: Bool = false
  var userAuthenticated: Bool = false
  
  func isGameCenterAvailable() -> Bool {
    // check for presence of GKLocalPlayer API
    
    let gcClass: AnyClass? = NSClassFromString("GKLocalPlayer")
    
    // check if the device is running iOS 4.1 or later
    let reqSysVer = "4.1"
    let osVersionSupported = UIDevice.currentDevice().systemVersion.compare(reqSysVer, options: NSStringCompareOptions.NumericSearch) != .OrderedAscending
    
    return gcClass != nil && osVersionSupported
  }
  
  override init() {
    super.init()
    if isGameCenterAvailable() {
      gameCenterAvailable = true
      let nc = NSNotificationCenter.defaultCenter()
      nc.addObserver(self, selector: "authenticationChanged", name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
  }
  
  func authenticationChanged() {
    if GKLocalPlayer.localPlayer().authenticated && !userAuthenticated {
      userAuthenticated = true
    } else if !GKLocalPlayer.localPlayer().authenticated && userAuthenticated {
      userAuthenticated = false
    }
  }
  
  func authenticateLocalUser() {
    if !gameCenterAvailable {
      return
    }
    
    if GKLocalPlayer.localPlayer().authenticated == false {
      GKLocalPlayer.localPlayer().authenticateHandler = {(viewController, error) -> Void in
        println("success")
      }
    }
  }
  
//  #pragma mark User functions
//  
//  - (void)authenticateLocalUser {
//  
//  if (!gameCenterAvailable) return;
//  
//  NSLog(@"Authenticating local user...");
//  if ([GKLocalPlayer localPlayer].authenticated == NO) {
//  [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:nil];
//  } else {
//  NSLog(@"Already authenticated!");
//  }
//  }
}
