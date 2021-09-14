//
//  Keyboardexide.swift
//  tynorios
//
//  Created by Acxiom Consulting on 12/11/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import UIKit

class Keyboardexide : NSObject, UITextFieldDelegate {
    var view: UIView!
    
        func textFieldDidBeginEditing(textField: UITextField) {
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector:  #selector(keyboardwillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)       
        
            }
    
    init(view: UIView!) {
        self.view = view
    }
        @objc func keyboardwillChange(notification: NSNotification) {
    
            guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
    
                return
            }
    
            if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame
            {
                  view.frame.origin.y = -keyboardRect.height
            }
            else
            {
                view.frame.origin.y = 0
            }
     }
    deinit {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            }
}
