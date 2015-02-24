//
//  MasterWalkthroughViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 24/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class MasterWalkthroughViewController: BWWalkthroughViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.nextButton!.setTitle("Next", forState: .Normal)
        self.prevButton!.setTitle("Previous", forState: .Normal)
        self.closeButton!.setImage(LookAndFeel.icons.closeWalkthroughIcon, forState: .Normal)
        self.closeButton!.setTitle(nil, forState: .Normal)
        
   
        self.nextButton?.tintColor = UIColor.whiteColor()
        self.nextButton?.backgroundColor = LookAndFeel.colorWithHexString("007AFF")
        self.nextButton?.layer.cornerRadius = 5
        self.nextButton?.clipsToBounds = true
        self.nextButton?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.prevButton?.tintColor = UIColor.whiteColor()
        self.prevButton?.backgroundColor = LookAndFeel.colorWithHexString("007AFF")
        self.prevButton?.layer.cornerRadius = 5
        self.prevButton?.clipsToBounds = true
        self.prevButton?.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
