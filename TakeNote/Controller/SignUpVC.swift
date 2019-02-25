//
//  SignUpVC.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-07-31.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var redoPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        self.redoPasswordTF.delegate = self
        // Do any additional setup after loading the view.
    }

 
    @IBAction func signUpBtn(_ sender: Any) {
        let email = emailTF.text
        let password = passwordTF.text
        
        if emailTF.text != "" && passwordTF.text != "" && redoPasswordTF.text != ""{
            
            if passwordTF.text != redoPasswordTF.text{//If passwords dont match
                self.showErrorAlert(errorMesssage: "passwords do not match")
                print("Error, passwords do not match")
            }else{//passwords match
                
                Auth.auth().createUser(withEmail: email!, password: password!) { (authResult, error) in//create user
                    if error != nil{ //if an error is found
                        
                        let err = error! as NSError
                        guard let errCode = AuthErrorCode(rawValue: err.code)
                            else { return }
                        
                        switch errCode { //Error codes
                            
                        case .invalidEmail:
                            print("error, invalid email")
                            self.showErrorAlert(errorMesssage: "invalid email")
                        case .emailAlreadyInUse:
                           print("error, an account already exists with this email")
                            self.showErrorAlert(errorMesssage: "an account already exists with this email")
                        case .weakPassword:
                            print("error, weak password")
                            self.showErrorAlert(errorMesssage: "weak password")
                        default:
                            print("error creating user")
                            self.showErrorAlert(errorMesssage: "error creating user")
                        }
                    }else{//No error is found creating the user
                        //Create the user in the db
                        let currentUser = Auth.auth().currentUser
                        
                        let userData = ["email": currentUser?.email,"provider": currentUser?.providerID ]
                        DataService.ds.createDbUser(uid: (currentUser?.uid)!, userData: userData)
                        //Push the view controller to main screen
                        self.performSegue(withIdentifier: SEGUE_TO_MAIN, sender: self)
                    }
                }
            }
        }else{//If all fields are empty
            self.showErrorAlert(errorMesssage: "All fields are empty")
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
    
}
