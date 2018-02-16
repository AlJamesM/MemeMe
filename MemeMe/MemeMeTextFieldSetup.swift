//
//  MemeMeTextFieldSetup.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

extension MemeMeViewController {
    
    func setupTextField( textField: UITextField, withText text: String ) {
        
        // Text attributes
        textField.defaultTextAttributes = memeTextAttributes
        
        // Text field setup
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = self
    }
}
