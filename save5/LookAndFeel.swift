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
        
        static let mainColor = LookAndFeel.colorWithHexString("54be39")
        static let secondaryColor = LookAndFeel.colorWithHexString("FED63A")
        static let thirdColor = LookAndFeel.colorWithHexString("2a2c2f")
        
        static let greenApple = LookAndFeel.colorFromRGB(76, green: 217, blue: 100)
        static let orangeApple = LookAndFeel.colorFromRGB(255, green: 149, blue: 0)
        static let darkBlueApple = LookAndFeel.colorFromRGB(0, green: 127, blue: 255)
        static let clearBlueApple = LookAndFeel.colorFromRGB(90, green: 200, blue: 250)
        static let yellowApple = LookAndFeel.colorFromRGB(255, green: 204, blue: 0)
        static let redApple = LookAndFeel.colorFromRGB(255, green: 59, blue: 48)
        static let grayApple = LookAndFeel.colorFromRGB(142, green: 142, blue: 147)
        static let pinkApple = LookAndFeel.colorFromRGB(255, green: 45, blue: 85)
        
        static let searchBarTextColor = LookAndFeel.colorWithHexString("f6f7f8")
        static let searchBarIconsColor = LookAndFeel.colorWithHexString("dfdfdf")
        static let colorTabBarItemNormal = LookAndFeel.colorWithHexString("aeaeae")
        
        static let titleBarFont:NSDictionary = [NSFontAttributeName:UIFont(name:"GeezaPro-Bold", size: 18)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        static let titleTabBarItemNormal:NSDictionary = [NSFontAttributeName:UIFont(name:"Avenir-Roman", size: 10)!, NSForegroundColorAttributeName:colorTabBarItemNormal]
        
        static let titleTabBarItemSelected:NSDictionary = [NSFontAttributeName:UIFont(name:"Avenir-Book", size: 10)!, NSForegroundColorAttributeName:thirdColor]
        
        static let loadingImage = UIImage(named: "loading_thumbnail.png")
        
        static let titleCellColor = LookAndFeel.colorWithHexString("767779")
        static let titleCellFont = UIFont (name: "Helvetica-Bold", size: 13)
        static let subtitleCellColor = LookAndFeel.colorWithHexString("EE606B")
        static let subtitleCellFont = UIFont (name: "HelveticaNeue", size: 10)
        static let subtitleMiniCellColor = LookAndFeel.colorWithHexString("858687")
        static let subtitleMiniCellFont = UIFont (name: "HelveticaNeue", size: 10)
        
        static let thumbnailBorderColor = LookAndFeel.colorWithHexString("9c9c9d")
        static let thumbnailBorderWidth = CGFloat(0.5)
        
        static let titleEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "AppleSDGothicNeo-SemiBold", size: 21)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("6f6f6f")]
        
        static let descriptionEmptyViewAttributes = [NSFontAttributeName:UIFont(name: "HelveticaNeue", size: 20)!, NSForegroundColorAttributeName:LookAndFeel.colorWithHexString("8f8f8f")]
        
        static let progressTrackColor = LookAndFeel.colorWithHexString("C7DAE0")
        static let progressColor = LookAndFeel.colorWithHexString("468499")
        static let progressTextFont = UIFont (name: "Avenir-Medium", size: 13)
        static let progressTextColor = LookAndFeel.colorWithHexString("77797C")
        static let progressStatusColor = LookAndFeel.colorWithHexString("EE606B")
        
        static let cellBackgroundColor = LookAndFeel.colorWithHexString("F4F4F4")
        static let cellHighlightColor = LookAndFeel.colorWithHexString("e5e5e5")
        
        static let titleWebRecentSearchesColor = LookAndFeel.colorWithHexString("434345")
        static let titleWebRecentSearchesFont = UIFont (name: "HelveticaNeue-Bold", size: 14)
        static let urlWebRecentSearchesColor = LookAndFeel.colorWithHexString("7e7e80")
        static let urlWebRecentSearchesFont = UIFont (name: "HelveticaNeue-Medium", size: 12)
        
        static let spaceHeightForEmptyDataSet = CGFloat(21.0)
    }
    
     struct icons {
    
        private static let barButtonItemSize:CGFloat = 24.0
        private static let toolbarButtonItemSize:CGFloat = 30.0
        private static let searchBarItemSize:CGFloat = 16.0
        private static let iconCellSize:CGFloat = 10.0
        private static let tabBarIconSize:CGFloat = 32.0
        
        static let numberVideosIcon = _numberVideosIcon
        static let lengthIcon = _lengthIcon
        static let spaceOnDiskIcon = _spaceOnDiskIcon
        static let addFolderIcon = _addFolderIcon
        static let searchVideosIcon = _searchVideosIcon
        static let stopLoadingIcon = _stopLoadingIcon
        static let reloadIcon = _reloadIcon
        static let clearIcon = _clearIcon
        static let searchIcon = _searchIcon
        static let emptyFolderIcon = _emptyFolderIcon
        static let goForwardWebHistoryIcon = _goForwardWebHistoryIcon
        static let goBackWebHistoryIcon = _goBackWebHistoryIcon
        static let goHomeWebHistoryIcon = _goHomeWebHistoryIcon
        static let webSearchSuggestionIcon = _webSearchSuggestionIcon
        static let closeWalkthroughIcon = _closeWalkthroughIcon
        static let noVideosInFolderIcon = _noVideosInFolderIcon
        static let noActiveDownloadsIcon = _noActiveDownloadsIcon
        static let deleteRecentSearchesIcon = _deleteRecentSearchesIcon
        static let searchVideosTabBarIcon = _searchVideosTabBarIcon
        static let foldersTabBarIcon = _foldersTabBarIcon
        static let downloadsTabBarIcon = _downloadsTabBarIcon
        static let clearFinishedDownloadsIcon = _clearFinishedDownloadsIcon
        static let deleteActiveDownloadsIcon = _deleteActiveDownloadsIcon
    }
    
    private class var _searchVideosTabBarIcon:UIImage  {
        
        var aux = FAKIonIcons.ios7WorldOutlineIconWithSize(icons.tabBarIconSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.colorTabBarItemNormal)
        
        return aux.imageWithSize(CGSize(width: icons.tabBarIconSize,height: icons.tabBarIconSize))
    }
    
    private class var _downloadsTabBarIcon:UIImage  {
        
        var aux = FAKIonIcons.ios7DownloadOutlineIconWithSize(icons.tabBarIconSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value:  style.colorTabBarItemNormal)
        
        return aux.imageWithSize(CGSize(width: icons.tabBarIconSize,height: icons.tabBarIconSize))
    }
    
    private class var _foldersTabBarIcon:UIImage  {
        
        var aux = FAKIonIcons.ios7VideocamOutlineIconWithSize(icons.tabBarIconSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.colorTabBarItemNormal)
        
        return aux.imageWithSize(CGSize(width: icons.tabBarIconSize,height: icons.tabBarIconSize))    }
    
    private class var _deleteRecentSearchesIcon:UIImage  {
        
        let aux = FAKIonIcons.trashAIconWithSize(icons.barButtonItemSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        
        return aux.imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _emptyFolderIcon:UIImage  {
        
        let aux = FAKIonIcons.ios7VideocamIconWithSize(CGFloat(40))
        
        aux.addAttribute(NSForegroundColorAttributeName, value: colorWithHexString("8F8F8F"))
        
        return aux.imageWithSize(CGSize(width: 40,height: 40))
    }
    
    private class var _numberVideosIcon:NSAttributedString  {
        
        let aux = FAKIonIcons.ios7VideocamOutlineIconWithSize(18)
        
        aux.addAttribute(NSForegroundColorAttributeName, value:  LookAndFeel.colorWithHexString("a9aaab"))
        
        return aux.attributedString()
    }
    
    private class var _lengthIcon:NSAttributedString  {
        
        let aux = FAKIonIcons.ios7PlayOutlineIconWithSize(18)
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.colorWithHexString("a9aaab"))
        
        return aux.attributedString()
    }
    
    private class var _noActiveDownloadsIcon:UIImage  {
        
        var aux = FAKIonIcons.closeCircledIconWithSize(85)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.colorWithHexString("AFAFAF"))
        
        return aux.imageWithSize(CGSize(width: 85,height: 85))
    }
    
    private class var _noVideosInFolderIcon:UIImage  {
        
        var aux = FAKIonIcons.ios7VideocamIconWithSize(85)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.colorWithHexString("a9aaab"))
        
        return aux.imageWithSize(CGSize(width: 85,height: 85))
    }
    
    private class var _spaceOnDiskIcon:NSAttributedString {
        
        let aux = FAKIonIcons.ios7BoxOutlineIconWithSize(18)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: LookAndFeel.colorWithHexString("C0C0C0"))
        
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
    
    private class var _clearFinishedDownloadsIcon:UIImage {
        
        return FAKIonIcons.closeIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _deleteActiveDownloadsIcon:UIImage {
        
        return FAKIonIcons.trashBIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _addFolderIcon:UIImage {
        
        return FAKIonIcons.plusIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _searchVideosIcon:UIImage {
        
        return FAKIonIcons.ios7SearchStrongIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.barButtonItemSize, height: icons.barButtonItemSize))
    }
    
    private class var _stopLoadingIcon: UIImage {
        
        var aux = FAKIonIcons.closeIconWithSize(icons.searchBarItemSize)
        
        aux.addAttribute(NSForegroundColorAttributeName, value: style.searchBarIconsColor)
        
        return aux.imageWithSize(CGSize(width: icons.searchBarItemSize, height: icons.searchBarItemSize))
    }
    
    private class var _reloadIcon: UIImage {
        
        var aux = FAKIonIcons.refreshIconWithSize(icons.searchBarItemSize)
        aux.addAttribute(NSForegroundColorAttributeName, value: style.searchBarIconsColor)
        return aux.imageWithSize(CGSize(width: icons.searchBarItemSize, height: icons.searchBarItemSize))
    }
    
    private class var _searchIcon: UIImage {
        
        var aux = FAKIonIcons.ios7SearchStrongIconWithSize(icons.searchBarItemSize+5)
        aux.addAttribute(NSForegroundColorAttributeName, value: style.searchBarIconsColor)
        return aux.imageWithSize(CGSize(width: icons.searchBarItemSize+5, height: icons.searchBarItemSize+5))
    }
    
    private class var _clearIcon: UIImage {
        
        var aux = FAKIonIcons.closeCircledIconWithSize(icons.searchBarItemSize)
        aux.addAttribute(NSForegroundColorAttributeName, value: style.searchBarIconsColor)
        return aux.imageWithSize(CGSize(width: icons.searchBarItemSize, height: icons.searchBarItemSize))
    }
    
    private class var _goForwardWebHistoryIcon:UIImage {
        
        return FAKIonIcons.ios7ArrowForwardIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.toolbarButtonItemSize, height: icons.toolbarButtonItemSize))
    }
    
    private class var _goBackWebHistoryIcon:UIImage {
        
        return FAKIonIcons.ios7ArrowBackIconWithSize(icons.barButtonItemSize).imageWithSize(CGSize(width: icons.toolbarButtonItemSize, height: icons.toolbarButtonItemSize))
    }
    
    private class var _goHomeWebHistoryIcon:UIImage {
        
        return FAKFontAwesome.homeIconWithSize(icons.toolbarButtonItemSize).imageWithSize(CGSize(width: icons.toolbarButtonItemSize, height: icons.toolbarButtonItemSize))
    }
    
    private init(){
        
        let navigationBarApp = UINavigationBar.appearance()
        navigationBarApp.barTintColor = style.mainColor
        navigationBarApp.tintColor = style.secondaryColor
        navigationBarApp.titleTextAttributes = style.titleBarFont
        navigationBarApp.translucent = false
   
        let tabBarApp = UITabBar.appearance()
        tabBarApp.barTintColor = LookAndFeel.colorWithHexString("FDFDFD")
        tabBarApp.tintColor = LookAndFeel.colorWithHexString("111111")
        tabBarApp.translucent = false
        tabBarApp.selectedImageTintColor = style.thirdColor
        
        let searchBarApp = UISearchBar.appearance()
        searchBarApp.barTintColor = style.mainColor
        searchBarApp.barStyle = UIBarStyle.BlackTranslucent
        
        let tableViewCellApp = UITableViewCell.appearance()
        tableViewCellApp.backgroundColor = style.cellBackgroundColor
        tableViewCellApp.selectionStyle = UITableViewCellSelectionStyle.Gray
            
        let collectionViewCellApp = UICollectionViewCell.appearance()
        collectionViewCellApp.backgroundColor = style.cellBackgroundColor
        
        
        let tableViewApp = UITableView.appearance()
        tableViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        let collectionViewApp = UICollectionView.appearance()
        collectionViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
      
        let webViewApp = UIWebView.appearance()
        webViewApp.backgroundColor = LookAndFeel.colorWithHexString("dfdfdf")
        
        let tableViewHeaderFooterViewApp = UITableViewHeaderFooterView.appearance()
        tableViewHeaderFooterViewApp.tintColor = LookAndFeel.colorWithHexString("383839")
     
        let toolbarApp = UIToolbar.appearance()
        toolbarApp.translucent = true
        toolbarApp.tintColor = LookAndFeel.colorWithHexString("858687")
        AppearanceWhenContainedIn.setAppearance()
     }
    
    class func colorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    class func colorFromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
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
