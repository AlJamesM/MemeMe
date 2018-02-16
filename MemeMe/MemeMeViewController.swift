//
//  ViewController.swift
//  MemeMe
//
//  Created by Al Manigsaca on 1/22/18.
//  Copyright © 2018 axillon. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController {
    
    // Tracks status of textField is were already touched
    var textFieldFirstSelected = [ true, true ]
    
    var imageAspectRatio = CGFloat()
    
    // MARK: - Outlets
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    @IBOutlet weak var memeContainerView: UIView!
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    @IBOutlet weak var memeContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var memeContainerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(textField: textFieldTop, withText: kMemeTextDefault[kMemeTextTop])
        setupTextField(textField: textFieldBottom, withText: kMemeTextDefault[kMemeTextBottom])
        
        setupTapGestureRecognizer()       // Setup keyboard hide Tap GR
        setupImageGestureRecognizers()    // Setup image Pan and Pinch GR
        setupInitialButtonsAvailability() // Disable buttons
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromNotifications()
    }
    
    func setupTapGestureRecognizer() {
        
        // for closing the keyboard
        let tapViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView))
        self.memeContainerView.addGestureRecognizer(tapViewGestureRecognizer)
        
    }
    
    func setupInitialButtonsAvailability() {
        
        // Initially disable the following
        cancelButton.isEnabled                 = false
        actionButton.isEnabled                 = false
        memeImageView.isUserInteractionEnabled = false
    }
    
    // MARK: - Notifications
    func subscribeToNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // Handle size adjustments after device rotation
    // Chose not to use constraints to be able to create my custom behavior
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            let newFrame = self.imageViewRect(aspect: self.imageAspectRatio)
            UIView.animate(withDuration: kAnimationTimeFast, animations: {
                self.memeImageView.frame = newFrame
            })
        })
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
        
        if textFieldBottom.isFirstResponder {
            
            memeContainerViewBottomConstraint.constant =   (getKeyboardHeight(notification) - toolBar.frame.size.height)
            memeContainerViewTopConstraint.constant    =  -(getKeyboardHeight(notification) - toolBar.frame.size.height)
            
            UIView.animate(withDuration: kAnimationTime) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if textFieldBottom.isFirstResponder  {
            
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
    
    func presentImagePickerWith( sourceType: UIImagePickerControllerSourceType ) {
        
        let imagePicker        = UIImagePickerController()
        imagePicker.delegate   = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    // open album
    @IBAction func albumButtonPressed(_ sender: UIBarButtonItem) {
        
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    // open camera
    @IBAction func photoButtonPressed(_ sender: UIBarButtonItem) {
        
        presentImagePickerWith(sourceType: .camera)
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
        textFieldTop.text         = kMemeTextDefault[kMemeTextTop]
        textFieldBottom.text      = kMemeTextDefault[kMemeTextBottom]
        
        textFieldFirstSelected    = [ true, true ]
        
        memeImageView.image       = nil                      // remove image
        memeImageView.frame       = memeContainerView.bounds // reset imageView frame
        
        cancelButton.isEnabled    = false
        actionButton.isEnabled    = false
        memeImageView.isUserInteractionEnabled = false
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
        
        let imageNewHeight : CGFloat = memeContainerView.bounds.width/(aspect != 0 ? aspect : 1.0)
        let imageNewWidth  : CGFloat = memeContainerView.bounds.width
        
        return CGRect.init(x: memeContainerView.bounds.width/2 - imageNewWidth/2, y:  memeContainerView.bounds.height/2 - imageNewHeight/2, width: imageNewWidth, height: imageNewHeight)
    }
}

