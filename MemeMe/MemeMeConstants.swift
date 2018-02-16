//
//  MemeMeConstants.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

// Text Field String Attributes
let kMemeTextColor                      = UIColor.white
let kMemeTextFont                       = UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!
let kMemeTextStrokeColor                = UIColor.black
let kMemeTextBorderWidth                = -1.0

// Text attributes dictionary (setup textField attributes)
// Reference - developer.apple.com/documentation/foundation/nsattributedstringkey

let memeTextAttributes:[ String : Any ] = [
    NSAttributedStringKey.foregroundColor.rawValue : kMemeTextColor,
    NSAttributedStringKey.font.rawValue            : kMemeTextFont,
    NSAttributedStringKey.strokeColor.rawValue     : kMemeTextStrokeColor,
    NSAttributedStringKey.strokeWidth.rawValue     : kMemeTextBorderWidth
]

// Text Field Default String Content
let kMemeTextTop = 0
let kMemeTextBottom = 1
let kMemeTextDefault = ["TOP", "BOTTOM"]

let kEmptyString                        = ""

// Animation time for moving textField up with the keyboard
let kAnimationTime                      = 0.3
let kAnimationTimeFast                  = 0.1

// Pinch maximum factor
let kScaleFactor : CGFloat              = 3.0
let kScaleBackFactor : CGFloat          = 0.9
