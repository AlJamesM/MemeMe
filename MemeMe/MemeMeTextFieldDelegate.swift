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
        
        if textFieldFirstSelected[textField.tag] {
            textField.text = kEmptyString
            textFieldFirstSelected[textField.tag] = false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let contentText = textField.text, contentText.isEmpty {
            textField.text = kMemeTextDefault[textField.tag]
            textFieldFirstSelected[textField.tag] = true
        }
    }
}
