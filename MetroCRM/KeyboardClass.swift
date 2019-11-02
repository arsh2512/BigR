//
//  KeyboardClass.swift
//  Kirana
//
//  Created by Harsha Krishnarao Warjurkar on 08/05/18.
//  Copyright © 2018 Harsha Krishnarao Warjurkar. All rights reserved.
//

import Foundation
import UIKit

class KeyboardClass {

    var scrollView = UIScrollView()
    var activeField = UITextField()
    var view = UIView()
    
    init(scrollView : UIScrollView, activeField : UITextField, view : UIView) {
        
        self.scrollView = scrollView
        self.activeField = activeField
        self.view = view
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
   
    // Called when the UIKeyboardWillHideNotification is sent
  @objc  func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
  @objc  func keyboardWillShow(aNotification: NSNotification) {
    var info = aNotification.userInfo
    let kbSize: CGSize? = ((info![UIResponder.keyboardFrameEndUserInfoKey]!) as AnyObject).cgRectValue.size
    let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (kbSize?.height)!, right: 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    var aRect: CGRect = view.frame
    aRect.size.height -= kbSize?.height ?? 0.0
    if !aRect.contains(activeField.frame.origin) {
        scrollView.scrollRectToVisible(activeField.frame, animated: true)
    }
    }
}
