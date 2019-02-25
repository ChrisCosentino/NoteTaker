//
//  ViewController.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-07-23.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase
import Popover

class NoteVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var sView: UIView!
    @IBOutlet weak var fontBtn: UIButton!
    
    var fetchedContent = [String]()
    var passedTitle: String!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        print(passedTitle)
        self.title = passedTitle
        self.fetchNote()
        self.editView.isHidden = true
        self.editView.bindToKeyboard()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
  
    /*
     This method moves the content of the textview up when keyboard is active
     */
    @objc func keyboardWillShow(_ notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 65, right: 0)
                textView.contentInset = contentInsets
            }
    
        }
    
    /*
     This method resets the content of the textview back to original when the keyboard is hidden
     */
    @objc func keyboardWillHide(_ notification: NSNotification) {
            let contentInsets = UIEdgeInsets.zero
            textView.contentInset = contentInsets
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.editView.isHidden = false
    }
    
    /*
     This method is run when the textview is done editing
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        // Run code here for when user ends editing text view
        self.editView.isHidden = true
    }

    
    /*
     Fetches the note to display into the textview
     */
    func fetchNote(){
        
       DataService.ds.REF_BASE.child("users").child((Auth.auth().currentUser?.uid)!).child(self.title!).observe(.value, with: { (snapshot) in
            
            var content: String = ""
            
            if let dict = snapshot.value as? [String:Any] {
               content = dict["content"] as! String
            }
            
            if self.textView.text == content{ // If the textview already equals the content from the db
                
            }else{ //If the textview doesnt equal the content from the db, make it equal to it
                self.textView.text = content
            }
           
            
        })
    }
    
    func textViewDidChange(_ textView: UITextView) { //Fires when the textview text changes
        print(textView.text)
        DataService.ds.REF_BASE.child("users").child((Auth.auth().currentUser?.uid)!).child(self.title!).child("content").setValue(textView.text)
    }
    
//    @IBAction func editBtn(_ sender: Any) {
//        self.editTitleAlert()
//        //Need to edit the title in firebase
//    }
    
    @IBAction func toolBarDoneBtn(_ sender: Any) {
        self.textView.endEditing(true)
    }

    
//    func editTitleAlert(){//Alert to change the title of note
//
//        let alertController = UIAlertController(title: "Edit Note Title", message: "", preferredStyle: UIAlertControllerStyle.alert)
//
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter new note title"
//        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
//            // do nothing when cancel button pressed
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { action in
//            // do something when save button pressed
//            let newTitle = alertController.textFields![0] as UITextField//gets the first textfield
//            self.title = newTitle.text!
//        }))
//
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func tabBtn(_ sender: Any) {
        textView.text.append("\t")
    }
    
    
    
}




