//
//  NoReturnKeyTextfield.swift
//  save5
//
//  Created by José Carlos Sobrino on 22/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class NoReturnKeyTextfield: NSObject, UITextFieldDelegate  {
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return false
    }
}
