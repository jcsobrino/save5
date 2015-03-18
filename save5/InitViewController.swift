//
//  InitViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 25/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class InitViewController: UITabBarController {

    private let webBrowserTabBarIndex = 0
    private let downloadTabBarIndex = 1
    private let storedTabBarIndex = 2
    
    private var numOfDownloadsNotSeen = 0
    private var numOfSavedVideosNotSeen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var tab1 = self.tabBar.items![webBrowserTabBarIndex] as UITabBarItem
        var tab2 = self.tabBar.items![downloadTabBarIndex] as UITabBarItem
        var tab3 = self.tabBar.items![storedTabBarIndex] as UITabBarItem
       
        for tab in self.tabBar.items! {
            
            tab.setTitleTextAttributes(LookAndFeel.style.titleTabBarItemNormal, forState: UIControlState.Normal)
            tab.setTitleTextAttributes(LookAndFeel.style.titleTabBarItemSelected, forState: UIControlState.Selected)
        }
        
        tab1.image = LookAndFeel.icons.searchVideosTabBarIcon.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        tab1.selectedImage = LookAndFeel.icons.searchVideosTabBarIcon.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        tab2.image = LookAndFeel.icons.downloadsTabBarIcon.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        tab2.selectedImage = LookAndFeel.icons.downloadsTabBarIcon.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        tab3.image = LookAndFeel.icons.foldersTabBarIcon.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        tab3.selectedImage = LookAndFeel.icons.foldersTabBarIcon.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
    
        tab1.title = Utils.localizedString("Find Videos")
        tab2.title = Utils.localizedString("Downloads")
        tab3.title = Utils.localizedString("Folders")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDownload:", name:DownloadManager.notification.newDownload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishDownload:", name:DownloadManager.notification.finishDownload, object: nil)
    }
    
    override func viewDidAppear(animated: Bool){
        
       super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newDownload(notification:NSNotification) {
        
        if (super.selectedIndex != downloadTabBarIndex) {
            
            let downloadTabBarItem =  super.tabBar.items![downloadTabBarIndex] as UITabBarItem
            numOfDownloadsNotSeen++
            
            Async.main {
                
                downloadTabBarItem.badgeValue = String(format:"%d", self.numOfDownloadsNotSeen)
            }
        }
    }
    
    func finishDownload(notification:NSNotification) {
        
        if (super.selectedIndex != storedTabBarIndex) {
            
            let storedTabBarItem =  super.tabBar.items![storedTabBarIndex] as UITabBarItem
            numOfSavedVideosNotSeen++
            
            Async.main {
                
                storedTabBarItem.badgeValue = String(format:"%d", self.numOfSavedVideosNotSeen)
            }
        }
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!)  {
        
        let indexSelected =  (super.tabBar.items! as NSArray).indexOfObject(item)
        
        switch(indexSelected){
            
            case downloadTabBarIndex: numOfDownloadsNotSeen = 0
            case storedTabBarIndex: numOfSavedVideosNotSeen = 0
            default:break
        }
        
        item.badgeValue = nil
    }
    
}
