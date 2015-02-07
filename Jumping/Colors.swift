//
//  Colors.swift
//  Jumping
//
//  Created by Kevin Greer on 12/23/14.
//  Copyright (c) 2014 Kevin Greer. All rights reserved.
//

import UIKit

extension UIColor{
    class func randomColor() -> UIColor {
        var r = CGFloat(drand48())
        var g = CGFloat(drand48())
        var b = CGFloat(drand48())
        
        return UIColor(red: r, green: g, blue:  b, alpha: 1.0)
    }
    
}
