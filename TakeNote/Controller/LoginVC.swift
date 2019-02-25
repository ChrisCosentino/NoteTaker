//
//  LoginVC.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-07-31.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{//If a user is signed in
                 self.performSegue(withIdentifier: SEGUE_TO_MAIN, sender: self)
            }else{//If a user is not signed in
                //stay on this page
            }
          
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)//remove the listener
        //clear the textfields when view disappears
        self.emailTF.text = ""
        self.passwordTF.text = ""
        
    }

    @IBAction func loginBtn(_ sender: Any) {
        let email = emailTF.text
        let password = passwordTF.text
        
        if email != "" && password != ""{ //If email and password fields are not empty
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if error != nil{ //if an error is found
                    
                    let err = error! as NSError
                    guard let errCode = AuthErrorCode(rawValue: err.code)
                        else { return }
                    
                    switch errCode { //Error codes
                        
                        
                    case .userNotFound:
                        self.showErrorAlert(errorMesssage: "An account with this email does not exist!")
                    case .userDisabled:
                        self.showErrorAlert(errorMesssage: "This account is disabled!")
                    case .invalidEmail:
                        self.showErrorAlert(errorMesssage: "Invalid email!")
                    case .networkError:
                        self.showErrorAlert(errorMesssage: "Network error!")
                    case .wrongPassword:
                        self.showErrorAlert(errorMesssage: "Incorrect password!")
                    default:
                        self.showErrorAlert(errorMesssage: "Unkown error logging in!")
                    }
                }else{//No error is found creating the user
                    //Push the view controller to main screen
                    self.performSegue(withIdentifier: SEGUE_TO_MAIN, sender: self)
                }
            }
        }else{//email or password textfield is empty
            self.showErrorAlert(errorMesssage: "The email or password field is empty!")
        }
        
    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
    }
    
  
    @IBAction func resetPasswordBtn(_ sender: Any) {
        self.showResetPasswordEmail()
        
    }
    
    private func showResetPasswordEmail(){
        
        let alert = UIAlertController(title: "Reset Password", message: "Enter your email associated with your account", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "email"
            textField.keyboardAppearance = .dark
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .default
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            // do nothing when cancel button pressed
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            
            // do something when save button pressed
            
            let email = alert.textFields![0].text!//gets the first textfield
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil{ //If there is no error
                    print("success")
                }else{
//                    let resetError = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
//                    print("hey there is an error")
//                    self.present(resetError, animated: true, completion: nil)
                }
            }
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    

    

}
