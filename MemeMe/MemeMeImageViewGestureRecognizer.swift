//
//  MemeMeImageViewGestureRecognizer.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

extension MemeMeViewController : UIGestureRecognizerDelegate {
    
    func setupImageGestureRecognizers() {
        
        // gesture recognizers for pinch and pan
        let panImageGestureRecognizer                    = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        panImageGestureRecognizer.maximumNumberOfTouches = 1
        panImageGestureRecognizer.delegate               = self
        memeImageView.addGestureRecognizer(panImageGestureRecognizer)
        
        let pinchImageGestureRecognizer      = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(_:)))
        pinchImageGestureRecognizer.delegate = self
        memeImageView.addGestureRecognizer(pinchImageGestureRecognizer)
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func panHandler(_ panGesture: UIPanGestureRecognizer) {
        
        struct Location {
            static var x : CGFloat = 0
            static var y : CGFloat = 0
        }
        
        if let panImageView = panGesture.view {
            
            switch panGesture.state {
            case .began:
                
                Location.x = panImageView.frame.origin.x
                Location.y = panImageView.frame.origin.y
                
            case .ended:
                
                alignToContainer(imageView: panImageView, isPinch: false)
                
            case .changed:
                
                let newXLocation = panGesture.translation(in: self.memeContainerView).x + Location.x
                let newYLocation = panGesture.translation(in: self.memeContainerView).y + Location.y
                
                panImageView.frame.origin.x = newXLocation
                panImageView.frame.origin.y = newYLocation
                
            default:
                
                print("no action here")
                
            }
        }
    }
    
    @objc func pinchHandler(_ pinchGesture: UIPinchGestureRecognizer) {
        
        // Reference for pinch to zoom gesture recognizer
        // developer.apple.com/documentation/uikit/touches_presses_and_gestures/handling_uikit_gestures/handling_pinch_gestures
        
        if let pinchImageView = pinchGesture.view {
            
            switch pinchGesture.state {
            case .ended:
                
                alignToContainer(imageView: pinchImageView, isPinch: true)
                
                if pinchImageView.frame.size.width >= (kScaleFactor * memeContainerView.frame.size.width) {
                    UIView.animate(withDuration: kAnimationTimeFast, animations: {
                        pinchImageView.transform = pinchImageView.transform.scaledBy(x: kScaleBackFactor, y: kScaleBackFactor)
                        pinchGesture.scale = 1.0 // Reset scale
                    })
                }
                
            case .changed, .began:
                
                // Limits the image maximum size
                if pinchImageView.frame.size.width < (kScaleFactor * memeContainerView.frame.size.width) {
                    
                    pinchImageView.transform = pinchImageView.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
                    pinchGesture.scale = 1.0 // Reset scale
                    
                }
                
            default:
                
                print("no action here")
                
            }
        }
    }
    
    // makes sure the image does not get outside the container view or is not too small
    func alignToContainer( imageView : UIView, isPinch: Bool ) {
        
        // handles the width and x origin and keep the image inside the container height
        // also keep the image centered when smaller that the container view
        
        if imageView.frame.size.width > memeContainerView.frame.size.width {
            if imageView.frame.origin.x > 0 {
                UIView.animate(withDuration: kAnimationTimeFast, animations: {
                    imageView.frame.origin.x = 0
                })
            }
            if ((imageView.frame.origin.x + imageView.frame.size.width) < self.memeContainerView.bounds.width) {
                UIView.animate(withDuration: kAnimationTimeFast, animations: {
                    imageView.frame.origin.x = imageView.frame.origin.x + (self.memeContainerView.bounds.width - (imageView.frame.origin.x + imageView.frame.size.width))
                })
            }
        } else {
            UIView.animate(withDuration: kAnimationTimeFast, animations: {
                imageView.frame.origin.x = self.memeContainerView.bounds.width/2 - imageView.frame.size.width/2
            })
        }
        
        // handles the width and y origin and keep the image inside the contaner width
        // also keep the image centered when smaller that the container view
        
        if imageView.frame.size.height > memeContainerView.frame.size.height {
            
            if imageView.frame.origin.y > 0 {
                UIView.animate(withDuration: kAnimationTimeFast, animations: {
                    imageView.frame.origin.y = 0
                })
            }
            
            if ((imageView.frame.origin.y + imageView.frame.size.height) < self.memeContainerView.bounds.height) {
                UIView.animate(withDuration: kAnimationTimeFast, animations: {
                    imageView.frame.origin.y = imageView.frame.origin.y + (self.memeContainerView.bounds.height - (imageView.frame.origin.y + imageView.frame.size.height))
                })
            }
            
        } else {
            UIView.animate(withDuration: kAnimationTimeFast, animations: {
                imageView.frame.origin.y = self.memeContainerView.bounds.height/2 - imageView.frame.size.height/2
            })
        }
        
        // Keeps the image to a minimum size (no maximun size is set at the time, something to add later)
        
        if imageView.frame.size.width <= self.memeContainerView.bounds.width && imageView.frame.size.height <= self.memeContainerView.bounds.height {
            let newFrame =  imageViewRect(aspect: imageAspectRatio)
            UIView.animate(withDuration: kAnimationTimeFast, animations: {
                imageView.frame = newFrame
            })
        }
    }
}
