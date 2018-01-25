//
//  MemeMeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

extension MemeMeViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // Set to true if bottom textField is selected
        
        isBottomTextFieldActive = textField.tag == kMemeTextFieldBottomTag ? true : false
    
        // Clear textField the first time its selected
        
        if fieldFirstSelected.top && textField.tag == kMemeTextFieldTopTag {
            textFieldTop.text = kEmptyString
            fieldFirstSelected.top = false
        }
        
        if fieldFirstSelected.bottom && textField.tag == kMemeTextFieldBottomTag {
            textFieldBottom.text = kEmptyString
            fieldFirstSelected.bottom = false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let topText = textFieldTop.text, topText.isEmpty {
            textFieldTop.text = kMemeTextDefaultTop
            fieldFirstSelected.top = true
        }
        
        if let bottomText = textFieldBottom.text, bottomText.isEmpty {
            textFieldBottom.text = kMemeTextDefaultBottom
            fieldFirstSelected.bottom = true
        }
    }
}
