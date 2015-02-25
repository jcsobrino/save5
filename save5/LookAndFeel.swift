//
//  LookAndFeel.swift
//  save5
//
//  Created by José Carlos Sobrino on 01/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class LookAndFeel {
   
    class var sharedInstance : LookAndFeel {
        
        struct Static {
            static let instance : LookAndFeel = LookAndFeel()
        }
       
        return Static.instance
    }
    
    struct style {
        
        static let mainColor = LookAndFeel.colorWithHexString("C25156")
        static let secondaryColor = LookAndFeel.colorFromRGB(51.0, green: 51.0, blue: 51.0)
        
        static let greenApple = LookAndFeel.colorFromRGB(76, green: 217, blue: 100)
        static let orangeApple = LookAndFeel.colorFromRGB(255, green: 149, blue: 0)
        static let darkBlueApple = LookAndFeel.colorFromRGB(0, green: 127, blue: 255)
        static let clearBlueApple = LookAndFeel.colorFromRGB(90, green: 200, blue: 250)
        static let yellowApple = LookAndFeel.colorFromRGB(255, green: 204, blue: 0)
        static let redApple = LookAndFeel.colorFromRGB(255, green: 59, blue: 48)
        static let grayApple = LookAndFeel.colorFromRGB(142, green: 142, blue: 147)
        static let pinkApple = LookAndFeel.colorFromRGB(255, green: 45, blue: 85)
        
        static let blueAction = LookAndFeel.colorWithHexString("0099cc")
        static let greenAction = LookAndFeel.colorWithHexString("34be6b")
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
        
        static let thumbnailBorderColor = LookAndFeel.colorWithHexString("9c9c9d")
        static let thumbnailBorderWidth = CGFloat(0.5)
        
        static let titleEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "Helvetica", size: 23)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("6f6f6f")]
        
        static let descriptionEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("8f8f8f")]
        
        static let progressTrackColor = LookAndFeel.colorWithHexString("C7DAE0")
        static let progressColor = LookAndFeel.colorWithHexString("468499")
        static let progressTextFont = UIFont (name: "Avenir-Medium", size: 13)
        static let progressTextColor = LookAndFeel.colorWithHexString("77797C")
        
        static let cellBackgroundColor = LookAndFeel.colorWithHexString("f5f5f5")
        
        static let titleWebRecentSearchesColor = LookAndFeel.colorWithHexString("434345")
        static let titleWebRecentSearchesFont = UIFont (name: "HelveticaNeue-Bold", size: 14)
        static let urlWebRecentSearchesColor = LookAndFeel.colorWithHexString("7e7e80")
        static let urlWebRecentSearchesFont = UIFont (name: "HelveticaNeue-Medium", size: 12)
    
        
        static let titleWalkthroughColor = LookAndFeel.colorWithHexString("2d2d2e")
        static let titleWalkthroughFont = UIFont (name: "AppleSDGothicNeo-Bold", size: 25)
        static let subtitleWalkthroughColor = LookAndFeel.colorWithHexString("717173")
        static let subtitleWalkthroughFont = UIFont (name: "KohinoorDevanagari-Medium", size: 18)
        static let textWalkthroughColor = LookAndFeel.colorWithHexString("a7a7a7")
        static let textWalkthroughFont = UIFont (name: "Avenir-Medium", size: 16)
        
    }
    
     struct icons {
    
        private static let barButtonItemSize:CGFloat = 24.0
        private static let toolbarButtonItemSize:CGFloat = 26.0
        private static let searchBarItemSize:CGFloat = 16.0
        private static let iconCellSize:CGFloat = 10.0
        
        static let numberVideosIcon = _numberVideosIcon
        static let lengthIcon = _lengthIcon
        static let spaceOnDiskIcon = _spaceOnDiskIcon
        static let addFolderIcon = _addFolderIcon
        static let searchVideosIcon = _searchVideosIcon
        static let stopLoadingIcon = _stopLoadingIcon
        static let reloadIcon = _reloadIcon
        static let emptyFolderIcon = _emptyFolderIcon
        static let goForwardWebHistoryIcon = _goForwardWebHistoryIcon
        static let goBackWebHistoryIcon = _goBackWebHistoryIcon
        static let goHomeWebHistoryIcon = _goHomeWebHistoryIcon
        static let webSearchSuggestionIcon = _webSearchSuggestionIcon
        static let closeWalkthroughIcon = _closeWalkthroughIcon
    }
    
    private class var _emptyFolderIcon:UIImage  {
        
        let aux = FAKIonIcons.ios7FilmOutlineIconWithSize(CGFloat(20))
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.imageWithSize(CGSize(width: 20,height: 20))
    }
    
    private class var _numberVideosIcon:NSAttributedString  {
        
        let aux = FAKFontAwesome.filmIconWithSize(icons.iconCellSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }
    
    private class var _lengthIcon:NSAttributedString  {
        
        let aux = FAKFontAwesome.playIconWithSize(icons.iconCellSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }
    
    private class var _spaceOnDiskIcon:NSAttributedString {
        
        let aux = FAKFontAwesome.archiveIconWithSize(icons.iconCellSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }
    
    private class var _webSearchSuggestionIcon:NSAttributedString {
        
        let aux = FAKIonIcons.searchIconWithSize(icons.searchBarItemSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.attributedString()
    }
    
    private class var _closeWalkthroughIcon:UIImage {
        
        let aux = FAKIonIcons.closeCircledIconWithSize(icons.barButtonItemSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))

    }
    
    
    private class var _addFolderIcon:UIImage {
        
        return FAKIonIcons.plusIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _searchVideosIcon:UIImage {
        
        return FAKIonIcons.ios7SearchStrongIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _stopLoadingIcon: UIImage {
        
        var aux = FAKIonIcons.closeIconWithSize(icons.searchBarItemSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        
        return aux.imageWithSize(CGSize(width: icons.searchBarItemSize, height: icons.searchBarItemSize))
    }
    
    private class var _reloadIcon: UIImage {
        
        var aux = FAKIonIcons.refreshIconWithSize(icons.searchBarItemSize)
        aux.addAttribute(NSForegroundColorAttributeName, value: style.subtitleMiniCellColor)
        return aux.imageWithSize(CGSize(width: icons.searchBarItemSize, height: icons.searchBarItemSize))
    }
    
    private class var _goForwardWebHistoryIcon:UIImage {
        
        return FAKIonIcons.arrowRightAIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.toolbarButtonItemSize, height: icons.toolbarButtonItemSize))
    }
    
    private class var _goBackWebHistoryIcon:UIImage {
        
        return FAKIonIcons.arrowLeftAIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.toolbarButtonItemSize, height: icons.toolbarButtonItemSize))
    }
    
    private class var _goHomeWebHistoryIcon:UIImage {
        
        return FAKIonIcons.homeIconWithSize(icons.toolbarButtonItemSize).imageWithSize(CGSize(width: icons.toolbarButtonItemSize, height: icons.toolbarButtonItemSize))
    }
    
    private init(){
        
        let navigationBarApp = UINavigationBar.appearance()
        navigationBarApp.barTintColor = style.mainColor
        navigationBarApp.tintColor = LookAndFeel.colorFromRGB(218, green: 153, blue: 102)
        navigationBarApp.titleTextAttributes = style.titleBarFont
        navigationBarApp.translucent = false
        
        let tabBarApp = UITabBar.appearance()
        tabBarApp.barTintColor = LookAndFeel.colorWithHexString("5a5255")
        tabBarApp.tintColor = style.mainColor
        tabBarApp.translucent = false
        tabBarApp.selectedImageTintColor = style.mainColor
        
        let searchBarApp = UISearchBar.appearance()
        searchBarApp.barTintColor = LookAndFeel.colorWithHexString("ffffff")
        searchBarApp.barStyle = UIBarStyle.BlackTranslucent
        
        let tableViewCellApp = UITableViewCell.appearance()
        tableViewCellApp.backgroundColor = style.cellBackgroundColor
       // tableViewCellApp.separatorInset = UIEdgeInsetsZero
       // tableViewCellApp.layoutMargins = UIEdgeInsetsZero
        tableViewCellApp.selectionStyle = UITableViewCellSelectionStyle.Gray
            
        let collectionViewCellApp = UICollectionViewCell.appearance()
        collectionViewCellApp.backgroundColor = style.cellBackgroundColor
        
        let tableViewApp = UITableView.appearance()
        tableViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        //tableViewApp.separatorInset = UIEdgeInsetsZero
        //tableViewApp.layoutMargins = UIEdgeInsetsZero
        
        let collectionViewApp = UICollectionView.appearance()
        collectionViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        let webViewApp = UIWebView.appearance()
        webViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        let tableViewHeaderFooterViewApp = UITableViewHeaderFooterView.appearance()
        tableViewHeaderFooterViewApp.tintColor = LookAndFeel.colorWithHexString("383839")
     
        AppearanceWhenContainedIn.setAppearance()
     }
    
    class func colorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
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
