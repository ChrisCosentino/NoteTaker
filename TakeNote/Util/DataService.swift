//
//  DataService.swift
//  TakeNote
//
//  Created by Chris Cosentino on 2018-07-31.
//  Copyright © 2018 Chris Cosentino. All rights reserved.
//

import Foundation
import Firebase




class DataService {
    
  
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    
    
    func createDbUser(uid: String, userData: Dictionary<String, Any>){
        REF_BASE.child("users").child(uid).updateChildValues(userData)
    }
}
