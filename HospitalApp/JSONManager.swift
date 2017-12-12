//
//  JSONManager.swift
//  HospitalApp
//
//  Created by Robert on 12/12/17.
//  Copyright © 2017 Robert González. All rights reserved.
//

import UIKit

class JSONManager: NSObject {
    
        var name: String
        var lastname: String
        var telephone: String
        var email: String
    
    init(name: String, lastname :String, telephone : String, email: String) {
            self.name = name
            self.lastname = lastname
            self.telephone = telephone
            self.email = email
        }
        
    
}
