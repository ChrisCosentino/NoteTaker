//
//  UIViewExtension.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-08-01.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginningFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - beginningFrame.origin.y


        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {

            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {//check user device
                //iPhone X
                 self.frame.origin.y += deltaY + 35
            }else{
                 self.frame.origin.y += deltaY
            }

        }, completion: nil)
        print("keyboard is shown")
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){

        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.frame.origin.y != 0 {
                if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {//check user device
                    //iPhone X
                  self.frame.origin.y += keyboardSize.height - 35
                }else{
                   self.frame.origin.y += keyboardSize.height
                }
                
            }
        }
        
        
        print("keyboard did hide")

    }
}
