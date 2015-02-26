//
//  RecentSearchTableViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 22/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var URL: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        lookAndFeel()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    private func lookAndFeel() {
    
        title.textColor = LookAndFeel.style.titleWebRecentSearchesColor
        title.font = LookAndFeel.style.titleWebRecentSearchesFont
 
        URL.textColor = LookAndFeel.style.urlWebRecentSearchesColor
        URL.font = LookAndFeel.style.urlWebRecentSearchesFont
     }

}
