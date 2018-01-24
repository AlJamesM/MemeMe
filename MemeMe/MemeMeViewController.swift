//
//  ViewController.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController {
    
    // Tracks if bottom text field is selected
    var isBottomTextFieldActive : Bool = false
    
    // Struct that tracks status of textField is were already touched
    var fieldFirstSelected = TextFieldFirstSelected()
    var imageAspectRatio : CGFloat = 1.0
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    @IBOutlet weak var memeContainerView: UIView!
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var memeContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var memeContainerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup textField attributes
        setupTextFields()
        
        // for closing the keyboard
        let tapViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView))
        self.memeContainerView.addGestureRecognizer(tapViewGestureRecognizer)
        
        // gesture recognizers for pinch and pan
        let panImageGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler(_:)))
        panImageGestureRecognizer.maximumNumberOfTouches = 1
        memeImageView.addGestureRecognizer(panImageGestureRecognizer)
        
        let pinchImageGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(_:)))
        memeImageView.addGestureRecognizer(pinchImageGestureRecognizer)
        
        // Initially disable cancel button
        cancelButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // enable or disable camera button
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraButton.isEnabled = true
        } else {
            cameraButton.isEnabled = false
        }
        
        subscribeToNotifications()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotifications()
    
    }
    
    // MARK: - Notifications
    func subscribeToNotifications() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientatioChanged(_:)), name: .UIDeviceOrientationDidChange, object: nil)
    
    }
    
    func unsubscribeFromNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    
    }
    
    // MARK: - Handle Orientation Change
    @objc func orientatioChanged(_ notification:Notification)  {
        
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) || UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            let newFrame = imageViewRect(aspect: imageAspectRatio)
            UIView.animate(withDuration: kAnimationTimeFast, animations: {
                self.memeImageView.frame = newFrame
            })
        }
    }
    
    // MARK: - Keyboard Show and Hide Functions
    func hideKeyboard() {
        
        textFieldTop.resignFirstResponder()
        textFieldBottom.resignFirstResponder()
    }
    
    // Hide keyboard is background container view is tapped
    @objc func tapBackgroundView() {
        
        hideKeyboard()
        
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if isBottomTextFieldActive {
            
            memeContainerViewBottomConstraint.constant =  -getKeyboardHeight(notification) + toolBar.frame.size.height
            memeContainerViewTopConstraint.constant    =  -getKeyboardHeight(notification) + toolBar.frame.size.height
            
            UIView.animate(withDuration: kAnimationTime) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if isBottomTextFieldActive {
            
            memeContainerViewBottomConstraint.constant = 0
            memeContainerViewTopConstraint.constant    = 0
            
            UIView.animate(withDuration: kAnimationTime) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo     = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Button Pressed Actions
    
    // open album
    @IBAction func albumButtonPressed(_ sender: UIBarButtonItem) {
        
        let imagePicker        = UIImagePickerController()
        imagePicker.delegate   = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // open camera
    @IBAction func photoButtonPressed(_ sender: UIBarButtonItem) {
    
        let imagePicker        = UIImagePickerController()
        imagePicker.delegate   = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // open sharing
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {(type, completed, items, error) in
        
            if completed {
            
                self.save( memedImage: memedImage )
            
            } else {
            
                print("share cancelled")
            
            }
        }
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.memeContainerView.frame.size)
        memeContainerView.drawHierarchy(in: self.memeContainerView.bounds, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // reset imageview to default settings
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    
        // reset textField to virgin status and default content
        fieldFirstSelected.top    = true
        fieldFirstSelected.bottom = true
        textFieldTop.text         = kMemeTextDefaultTop
        textFieldBottom.text      = kMemeTextDefaultBottom

        memeImageView.image       = nil                      // remove image
        memeImageView.frame       = memeContainerView.bounds // reset imageView frame
        
        cancelButton.isEnabled    = false
    }
    
    // MARK: - Misc
    // Save the Meme
    func save( memedImage : UIImage? ) {
    
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: memeImageView.image!, memedImage: memedImage )
        print("Image Saved - Top Text: \(meme.topText!) Bottom Text: \(meme.bottomText!)")
    
    }
    
    // status bar setup
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // position image correctly if size is smaller than the container view
    func imageViewRect( aspect: CGFloat ) -> CGRect {
        
        let imageNewHeight : CGFloat = memeContainerView.bounds.width/aspect
        let imageNewWidth  : CGFloat = memeContainerView.bounds.width
        
        return CGRect.init(x: memeContainerView.bounds.width/2 - imageNewWidth/2, y:  memeContainerView.bounds.height/2 - imageNewHeight/2, width: imageNewWidth, height: imageNewHeight)
        
    }
}

