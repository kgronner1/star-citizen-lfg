//
//  Utilities.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 3/28/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    
    static func isEmailValid(_ email : String) -> Bool {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return emailPred.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordPred.evaluate(with: password)
    }
    
}
