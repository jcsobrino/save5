//
//  Extensions.swift
//  save5
//
//  Created by José Carlos Sobrino on 12/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar{
    
    
    func getTextField() -> UITextField? {
        
        for subview in self.subviews[0].subviews {
            
            if subview is UITextField{
                
                return subview as? UITextField
            }
        }
        
        return nil
    }
    
    func setTextAlignment(textAlign: NSTextAlignment){
        
        getTextField()?.textAlignment = textAlign
    }

}