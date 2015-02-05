//
//  LookAndFeel.swift
//  save5
//
//  Created by José Carlos Sobrino on 01/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class LookAndFeel: NSObject {
   
    struct style {
        
        static let mainColor = LookAndFeel.colorWithHexString("3B5A97") // Utils.colorFromRGB(0.0, green: 117.0, blue: 246.0) //
        static let secondaryColor = LookAndFeel.colorFromRGB(51.0, green: 51.0, blue: 51.0)
        static let rojoOscuro = LookAndFeel.colorFromRGB(158.0, green: 12.0, blue: 57.0)
        static let verdeOscuro = LookAndFeel.colorFromRGB(24.0, green: 155.0, blue: 137.0)
        static let turquesa = LookAndFeel.colorFromRGB(15, green: 146, blue: 191)
        
        static let greenApple = LookAndFeel.colorFromRGB(76, green: 217, blue: 100)
        static let orangeApple = LookAndFeel.colorFromRGB(255, green: 149, blue: 0)
        static let darkBlueApple = LookAndFeel.colorFromRGB(0, green: 127, blue: 255)
        static let clearBlueApple = LookAndFeel.colorFromRGB(90, green: 200, blue: 250)
        static let yellowApple = LookAndFeel.colorFromRGB(255, green: 204, blue: 0)
        static let redApple = LookAndFeel.colorFromRGB(255, green: 59, blue: 48)
        static let grayApple = LookAndFeel.colorFromRGB(142, green: 142, blue: 147)
        static let pinkApple = LookAndFeel.colorFromRGB(255, green: 45, blue: 85)
        
        
        static let titleBarFont:NSDictionary = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17.0), NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        static let loadingImage = UIImage(named: "loading_thumbnail.png")
        
        static let titleCellColor = LookAndFeel.colorWithHexString("224488")
        static let titleCellFont = UIFont (name: "Helvetica-Bold", size: 13)
        static let subtitleCellColor = LookAndFeel.colorWithHexString("3f3f3f")
        static let subtitleCellFont = UIFont (name: "Helvetica", size: 12)
        static let subtitleMiniCellColor = LookAndFeel.colorWithHexString("7f7f7f")
        static let subtitleMiniCellFont = UIFont (name: "HelveticaNeue", size: 11)
        static let textMoreDataCellColor = rojoOscuro
        static let textMoreDataCellFont = UIFont (name: "Helvetica-Bold", size: 16)
        static let backgroundColorMoreDataCell = LookAndFeel.colorWithHexString("fdfdfd")
        
        static let titleEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "Helvetica", size: 23)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("6f6f6f")]
        
        static let descriptionEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("8f8f8f")]
        
    }
    
    override init(){
        
        let navigationBarApp = UINavigationBar.appearance()
        navigationBarApp.barTintColor = style.mainColor
        navigationBarApp.tintColor = LookAndFeel.colorWithHexString("DA9966")
        navigationBarApp.titleTextAttributes = style.titleBarFont
        
        let tabBarApp = UITabBar.appearance()
        tabBarApp.barTintColor = LookAndFeel.colorWithHexString("dfdfdf")
        tabBarApp.tintColor = style.mainColor
        
        let searchBarApp = UISearchBar.appearance()
        searchBarApp.barTintColor = LookAndFeel.colorWithHexString("afafaf")
        
        let tableViewCellApp = UITableViewCell.appearance()
        tableViewCellApp.backgroundColor = LookAndFeel.colorWithHexString("fdfdfd")
        
        let collectionViewCellApp = UICollectionViewCell.appearance()
        collectionViewCellApp.backgroundColor = LookAndFeel.colorWithHexString("fdfdfd")
        
        let tableViewApp = UITableView.appearance()
        tableViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        let collectionViewApp = UICollectionView.appearance()
        collectionViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        AppearanceWhenContainedIn.setAppearance()
        
        let barButtonItemApp = UIBarButtonItem.appearance()
    }
    
    class func colorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    class func loadImage(name:String, type:String) -> UIImage {
        
        let path = NSBundle.mainBundle().pathForResource(name, ofType: type)!
        return UIImage(contentsOfFile: path)!
    }
    
    class func colorWithHexString (hex:String) -> UIColor {
        
        var cString:NSString = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(1)
        }
        
        if (cString.length != 6) {
            return UIColor.grayColor()
        }
        
        var rString = cString.substringToIndex(2)
        var gString = cString.substringWithRange(NSRange(location: 2, length: 2))
        var bString = cString.substringWithRange(NSRange(location: 4, length: 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}
