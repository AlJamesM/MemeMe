//
//  MemeMeImagePickerDelegate.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

extension MemeMeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // setup imageView and frame size based on the original image aspect ratio
            
            let imageWidth  : CGFloat = image.size.width
            let imageHeight : CGFloat = image.size.height
            
            let imageAspect = imageWidth/imageHeight
            self.imageAspectRatio = imageAspect
            
            let newFrame = imageViewRect(aspect: imageAspect)
            
            memeImageView.frame = newFrame
            memeImageView.image = image
            
            cancelButton.isEnabled = true
            actionButton.isEnabled = true
            memeImageView.isUserInteractionEnabled = true
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
}
