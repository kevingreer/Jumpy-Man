//
//  AppDelegate.swift
//  Jumping
//
//  Created by Kevin Greer on 12/22/14.
//  Copyright (c) 2014 Kevin Greer. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        do {
            // Override point for customization after application launch.
      
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch _ {
        }
        GameCenterManager.sharedInstance.authenticateLocalUser()
        
        return true
    }

}

