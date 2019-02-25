//
//  ErrorAlert.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-08-01.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func showErrorAlert(errorMesssage: String){
        let alert = UIAlertController(title: "Error", message: errorMesssage, preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            
        }))
        
        
        
        self.present(alert, animated: true, completion: nil)
    }
}




    




