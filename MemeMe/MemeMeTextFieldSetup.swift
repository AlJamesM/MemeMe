//
//  MemeMeTextFieldSetup.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

extension MemeMeViewController {

    func setupTextFields() {
        
        // Text attributes dictionary (setup textField attributes)
        // Reference - developer.apple.com/documentation/foundation/nsattributedstringkey
        
        let memeTextAttributes:[ String : Any ] = [
            NSAttributedStringKey.foregroundColor.rawValue : kMemeTextColor,
            NSAttributedStringKey.font.rawValue            : kMemeTextFont,
            NSAttributedStringKey.strokeColor.rawValue     : kMemeTextStrokeColor,
            NSAttributedStringKey.strokeWidth.rawValue     : kMemeTextBorderWidth
        ]
        
        // Set textField default text attributes
        textFieldTop.defaultTextAttributes    = memeTextAttributes
        textFieldBottom.defaultTextAttributes = memeTextAttributes
        
        // Text field setup
        
        textFieldTop.text             = kMemeTextDefaultTop
        textFieldTop.textAlignment    = .center
        textFieldTop.delegate         = self
        
        textFieldBottom.text          = kMemeTextDefaultBottom
        textFieldBottom.textAlignment = .center
        textFieldBottom.delegate      = self
    }
}
