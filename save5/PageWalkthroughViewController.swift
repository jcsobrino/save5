//
//  PageWalkthroughViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 24/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class PageWalkthroughViewController: BWWalkthroughPageViewController {

    var titlePage: UILabel!
    var subtitlePage: UILabel!
    var textPage: UILabel!
    var picture: UIImageView!
    
     init(title:String, subtitle:String, text:String, imageName: String){
       
        super.init(nibName: nil, bundle: nil);
        
        setupViews(title, subtitle:subtitle, text:text, imageName: imageName)
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupViews(title:String, subtitle:String, text:String, imageName: String){
        
        let superview = self.view
        
        titlePage = UILabel()
        titlePage.setTranslatesAutoresizingMaskIntoConstraints(false)
        titlePage.textAlignment = NSTextAlignment.Center
        titlePage.text = title
        titlePage.backgroundColor = LookAndFeel.colorWithHexString("F5F5F5")
        titlePage.font = LookAndFeel.style.titleWalkthroughFont
        titlePage.tintColor = LookAndFeel.style.titleWalkthroughColor
        superview.addSubview(titlePage)
        
        subtitlePage = UILabel()
        subtitlePage.setTranslatesAutoresizingMaskIntoConstraints(false)
        subtitlePage.textAlignment = NSTextAlignment.Center
        subtitlePage.text = subtitle
        subtitlePage.backgroundColor = LookAndFeel.colorWithHexString("F5F5F5")
        subtitlePage.font = LookAndFeel.style.subtitleWalkthroughFont
        subtitlePage.tintColor = LookAndFeel.style.subtitleWalkthroughColor
        superview.addSubview(subtitlePage)
        
        textPage = UILabel()
        textPage.setTranslatesAutoresizingMaskIntoConstraints(false)
        textPage.textAlignment = NSTextAlignment.Center
        textPage.text = text
        textPage.backgroundColor = LookAndFeel.colorWithHexString("F5F5F5")
        textPage.font = LookAndFeel.style.textWalkthroughFont
        textPage.tintColor = LookAndFeel.style.textWalkthroughColor
        textPage.numberOfLines = 0
        textPage.lineBreakMode = NSLineBreakMode.ByWordWrapping
        superview.addSubview(textPage)
        
        picture = UIImageView()
        picture.setTranslatesAutoresizingMaskIntoConstraints(false)
        picture.image = UIImage(named: imageName)
        picture.backgroundColor = LookAndFeel.colorWithHexString("F5F5F5")
        picture.contentMode = UIViewContentMode.ScaleAspectFit
        superview.addSubview(picture)
        
        let viewsDictionary = ["titlePage": titlePage, "subtitlePage": subtitlePage, "textPage": textPage, "picture": picture]
        
        titlePage.sizeToFit()
        subtitlePage.sizeToFit()
        textPage.sizeToFit()
        
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titlePage]-|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))
        
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[picture]-|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))
        
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[subtitlePage]-|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))

        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[textPage]-|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))
        
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-45-[titlePage(20)]-20-[picture]-5-[subtitlePage][textPage]-100-|",
            options: nil,
            metrics: nil,
            views: viewsDictionary))
        
        
    }
}
