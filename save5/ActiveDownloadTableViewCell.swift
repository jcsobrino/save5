//
//  ActiveDownloadTableViewCell.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class ActiveDownloadTableViewCell: UITableViewCell {
    
    var circularProgress:DALabeledCircularProgressView?
    
    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ETA: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var remainingTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circularProgress = DALabeledCircularProgressView(frame: progressView.bounds)
        circularProgress!.autoresizingMask = .FlexibleLeftMargin | .FlexibleRightMargin
        progressView.addSubview(circularProgress!)
        circularProgress!.roundedCorners = 1
        circularProgress!.trackTintColor = UIColor.blueColor()
        circularProgress!.progressTintColor = UIColor.redColor()
        
        lookAndFeel()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func lookAndFeel(){
        
        //self.backgroundColor = LookAndFeel.style.orangeApple
        name.textColor = LookAndFeel.style.titleCellColor
        name.font = LookAndFeel.style.titleCellFont
        hostname.textColor = LookAndFeel.style.rojoOscuro
        hostname.font = LookAndFeel.style.subtitleCellFont
        ETA.textColor = LookAndFeel.style.subtitleMiniCellColor
        ETA.font = LookAndFeel.style.subtitleMiniCellFont
        remainingTime.textColor = LookAndFeel.style.subtitleMiniCellColor
        remainingTime.font = LookAndFeel.style.subtitleMiniCellFont
    }

}
