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
        
        
        static let blueAction = LookAndFeel.colorWithHexString("0099cc")
        static let greenAction = LookAndFeel.colorWithHexString("1eb75b")
        static let redAction = LookAndFeel.colorWithHexString("ff4444")
        static let yellowAction = LookAndFeel.colorWithHexString("f9d44f")
        static let orangeAction = LookAndFeel.colorWithHexString("f4511e")
        static let purpleAction = LookAndFeel.colorWithHexString("2b5796")
        static let pinkAction = LookAndFeel.colorWithHexString("c64a88")
        
        static let searchBarTextColor = LookAndFeel.colorWithHexString("acb4be")
        
        static let titleBarFont:NSDictionary = [NSFontAttributeName:UIFont.boldSystemFontOfSize(17.0), NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        static let loadingImage = UIImage(named: "loading_thumbnail.png")
        
        static let titleCellColor = LookAndFeel.colorWithHexString("717173")
        static let titleCellFont = UIFont (name: "HelveticaNeue-Bold", size: 13)
        static let subtitleCellColor = LookAndFeel.colorWithHexString("8d8d8f")
        static let subtitleCellFont = UIFont (name: "HelveticaNeue-Medium", size: 11)
        static let subtitleMiniCellColor = LookAndFeel.colorWithHexString("727274")
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
    
        static let barButtonItemSize:CGFloat = 24.0
        static let searchBarItemSize:CGFloat = 16.0
        static let iconCellSize:CGFloat = 10.0
    }
    
    lazy var numberVideosIcon:NSAttributedString = {
        
        let size = LookAndFeel.icons.iconCellSize
        let aux = FAKFontAwesome.filmIconWithSize(size)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }()
    
    lazy var lengthIcon:NSAttributedString = {
        
        let size = LookAndFeel.icons.iconCellSize
        let aux = FAKFontAwesome.playIconWithSize(size)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }()
    
    lazy var spaceOnDiskIcon:NSAttributedString = {
        
        let size = LookAndFeel.icons.iconCellSize
        let aux = FAKFontAwesome.archiveIconWithSize(size)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }()
    
    lazy var addFolderIcon:UIImage = {
        
        let size = LookAndFeel.icons.barButtonItemSize
        return FAKIonIcons.plusIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
    }()
    
    lazy var searchVideosIcon:UIImage = {
        
        let size = LookAndFeel.icons.barButtonItemSize
        return FAKIonIcons.ios7SearchStrongIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
    }()
    
    lazy var stopLoadingIcon: UIImage = {
        
        let size = LookAndFeel.icons.searchBarItemSize
        var aux = FAKIonIcons.closeIconWithSize(size)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        
        return aux.imageWithSize(CGSize(width: size, height: size))
    }()
    
    lazy var reloadIcon: UIImage = {
        
        let size = LookAndFeel.icons.searchBarItemSize
        var aux = FAKIonIcons.refreshIconWithSize(size)
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.style.subtitleMiniCellColor)
        return aux.imageWithSize(CGSize(width: size, height: size))
    }()
    
    
    
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
        //tabBarApp.shadowImage = LookAndFeel.imageWithHex("B84146", )
        tabBarApp.selectedImageTintColor = LookAndFeel.style.mainColor
        //tabBarApp.selectionIndicatorImage = LookAndFeel.imageWithHex("444444", size: CGSizeMake(64, 49))
        
        
        let searchBarApp = UISearchBar.appearance()
        searchBarApp.barTintColor = LookAndFeel.colorWithHexString("ffffff")
       // searchBarApp.translucent = true
        searchBarApp.barStyle = UIBarStyle.BlackTranslucent
        //searchBarApp.tintColor  = UIColor.whiteColor()
        
      
        
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
    
    class func imageWithHex(hex: String, size:CGSize) -> UIImage {
    
        var rect = CGRectMake(0.0, 0.0, size.width, size.height)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
    
        var color = colorWithHexString(hex)
        
        //CGContextSetFillColorWithColor(context, color.CGColor)
        //CGContextFillRect(context, rect)
    
        color.setFill()
        UIRectFill(rect)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return image
    }
    

}
