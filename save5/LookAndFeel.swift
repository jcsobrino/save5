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
        
        static let mainColor = LookAndFeel.colorWithHexString("C25156")//"3B5A97") // Utils.colorFromRGB(0.0, green: 117.0, blue: 246.0) //
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
        
        
        static let blueAction = LookAndFeel.colorWithHexString("1b85b8")
        static let greenAction = LookAndFeel.colorWithHexString("738677")
        static let redAction = LookAndFeel.colorWithHexString("FF4040")
        
        static let titleBarFont:NSDictionary = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17.0), NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        static let loadingImage = UIImage(named: "loading_thumbnail.png")
        
        static let titleCellColor = LookAndFeel.colorWithHexString("717173")
        static let titleCellFont = UIFont (name: "HelveticaNeue-Bold", size: 13)
        static let subtitleCellColor = LookAndFeel.colorWithHexString("8d8d8f")
        static let subtitleCellFont = UIFont (name: "HelveticaNeue-Medium", size: 11)
        static let subtitleMiniCellColor = LookAndFeel.colorWithHexString("7f7f81")
        static let subtitleMiniCellFont = UIFont (name: "HelveticaNeue-Light", size: 10)
        static let textMoreDataCellColor = rojoOscuro
        static let textMoreDataCellFont = UIFont (name: "Helvetica-Bold", size: 16)
        static let backgroundColorMoreDataCell = LookAndFeel.colorWithHexString("fdfdfd")
        
        static let titleEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "Helvetica", size: 23)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("6f6f6f")]
        
        static let descriptionEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("8f8f8f")]
        
        static let progressTrackColor = LookAndFeel.colorWithHexString("C7DAE0")
        static let progressColor = LookAndFeel.colorWithHexString("468499")
        static let progressTextFont = UIFont (name: "Avenir-Medium", size: 13)
        static let progressTextColor = LookAndFeel.colorWithHexString("77797C")
        
    
        static let cellBackgroundColor = LookAndFeel.colorWithHexString("f5f5f5")
    }
    
    
    struct icons {
    
        static let playVideoCell = FAKFontAwesome.playIconWithSize(11)
        static let spaceOnDisk = FAKFontAwesome.archiveIconWithSize(11)
       
        init() {
            
            //playVideoCell.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
            //spaceOnDisk.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        }
        
        
        
    }
    
    
    override init(){
        
        let navigationBarApp = UINavigationBar.appearance()
        navigationBarApp.barTintColor = style.mainColor
        navigationBarApp.tintColor = LookAndFeel.colorFromRGB(218, green: 153, blue: 102)
        navigationBarApp.titleTextAttributes = style.titleBarFont
        navigationBarApp.translucent = false
        
        
        
        
        let tabBarApp = UITabBar.appearance()
        tabBarApp.barTintColor = LookAndFeel.colorWithHexString("5a5255")
        tabBarApp.tintColor = LookAndFeel.style.mainColor
        tabBarApp.translucent = false
        tabBarApp.shadowImage = LookAndFeel.imageWithHex("B84146")
        
        let searchBarApp = UISearchBar.appearance()
        searchBarApp.barTintColor = LookAndFeel.colorWithHexString("ffffff")
       // searchBarApp.translucent = true
        searchBarApp.barStyle = UIBarStyle.BlackTranslucent
        
        
      
        
        let tableViewCellApp = UITableViewCell.appearance()
        tableViewCellApp.backgroundColor = LookAndFeel.style.cellBackgroundColor
        tableViewCellApp.separatorInset = UIEdgeInsetsZero
        tableViewCellApp.layoutMargins = UIEdgeInsetsZero
        tableViewCellApp.selectionStyle = UITableViewCellSelectionStyle.Gray
            
        let collectionViewCellApp = UICollectionViewCell.appearance()
        collectionViewCellApp.backgroundColor = LookAndFeel.style.cellBackgroundColor
        
        let tableViewApp = UITableView.appearance()
        tableViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        tableViewApp.separatorInset = UIEdgeInsetsZero
        tableViewApp.layoutMargins = UIEdgeInsetsZero
        
        let collectionViewApp = UICollectionView.appearance()
        collectionViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        let webViewApp = UIWebView.appearance()
        webViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        
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
    
    class func imageWithHex(hex: String) -> UIImage {
    
        var rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
    
        var color = colorWithHexString(hex)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
    
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image
    }

}
