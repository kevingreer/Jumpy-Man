//
//  BarrelTimeManager.swift
//  Jumpy Man
//
//  Created by Kevin Greer on 7/9/15.
//  Copyright (c) 2015 Kevin Greer. All rights reserved.
//

import SpriteKit

class BarrelTimeManager: NSObject {
  
  static let sharedInstance = BarrelTimeManager()
  
  let AbsoluteMinimumTime: NSTimeInterval = 0.5
  let SecondaryMinimumTime: NSTimeInterval = 0.7
  
  var justSentMinimum = false
  var sendFast = false
  
  let Variance: NSTimeInterval = 0.25
  let FastChance: UInt32 = 5 //Percent of fast
  let InitialInterval: NSTimeInterval = 2.0
  
  
  func getNextTime() -> NSTimeInterval {
    
    let rand = arc4random() % 100
    if rand < FastChance {
      sendFast = true
      return InitialInterval
    } else {
      sendFast = false
    }
    
    
    var interval: NSTimeInterval = NSTimeInterval(CGFloat(drand48() * Variance + AbsoluteMinimumTime))
    
    if interval < SecondaryMinimumTime {
      if justSentMinimum{
        justSentMinimum = false
        interval = SecondaryMinimumTime
      } else {
        justSentMinimum = true
      }
    }
  
    return interval
  }
  
  func reset() {
    justSentMinimum = false
    sendFast = false
  }
}
