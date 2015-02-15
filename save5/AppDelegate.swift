//
//  AppDelegate.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ch : (() -> ())!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
      
        LookAndFeel();
        FolderDAO.sharedInstance.getDefaultFolder()
        
        application.statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        
        var tabBarController = self.window?.rootViewController as UITabBarController
        
        var tab1 = tabBarController.tabBar.items![0] as UITabBarItem
        var tab2 = tabBarController.tabBar.items![1] as UITabBarItem
        var tab3 = tabBarController.tabBar.items![2] as UITabBarItem
      
        let size = CGFloat(30)
        
        
        let image1 = FAKIonIcons.ios7WorldIconWithSize(size)
        
        image1.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        
        
        tab1.image = image1.imageWithSize(CGSize(width: size, height: size))
        //tab2.image = FAKIonIcons.ios7DownloadIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
        tab2.image = FAKIonIcons.archiveIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
        tab3.image = FAKIonIcons.ios7VideocamIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
        
        
        
        
        tab1.title = "Find Vídeos"
        tab2.title = "Downloads"
        tab3.title = "Folders"
        
       // loadData()
        return true
    }
    
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
     
        println("hello hello, storing completion handler")
        self.ch = completionHandler
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
        println("calling completion handler")
        
        if self.ch != nil {
        
            self.ch()
        }
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jcs.save5" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("save5", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("save5.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    func loadData(){
        
        var url = NSURL(string: "http://r5---sn-w511uxa-cjol.googlevideo.com/videoplayback?ipbits=0&ip=37.133.85.201&key=yt5&id=o-AGnVrszfT0db_kxuFBhJO_nnUOjdXVyxZQ_BJIBcaoxb&upn=9SKexuBFtXQ&el=watch&dnc=1&mm=31&yms=UVTLNyrawkk&ms=au&mt=1423914737&mv=m&cwbhb=yes&source=youtube&gcr=es&expire=1423936400&itag=18&sparams=cwbhb%2Cgcr%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&fexp=900228%2C904732%2C907263%2C912332%2C927622%2C934050%2C934954%2C9406392%2C943917%2C945111%2C947225%2C948124%2C952302%2C952605%2C952612%2C952901%2C955301%2C957201%2C958600%2C959701&ratebypass=yes&initcwndbps=1167500&app=youtube_mobile&sver=3&signature=1DFA04638FFF86428634025D82D7CE27A3B89B5E.175EEA5B74434366FB990B70065DCE8A0C7C31D3&pl=22&cpn=r5xCL4tn5-rmPJIe&ptk=youtube_multi&oid=YbGWGCIUCoaUePqGy_acMw.SlODfwbK82f2lVHy5P82EA.LtuniTgT0PFayH9n3PW4_A.L2YoOATTFNKUmlyfk-e46g.VQ5wm0lngw_sYJ8j6-Q5sA.TsT5ztlcfu8EsWy2ztsauA.9b8naKhAjYHfDP3yKaWKtg.4dOQzkkEMJNCYo3NvbMU0w.uI4xbVg9HpiLJYr01T0REQ.vk4QB2WZXzEBs2lFNB4Gcw.8Td-asijjguOS4RL5HexHg.psVOfacGQAUoDS5qYWddjw._oUY04CjXA-qJSYHUIUFBQ&pltype=contentugc&c=MWEB&cver=html5")!
        
           DownloadManager.sharedInstance.downloadVideo(url, name: "Este es un texto mucho más largo. Necesito que sea lo bastante largo para que ocupe al menos tres líneas", sourcePage: "http://youtube.com", folder: nil)
        
        DownloadManager.sharedInstance.downloadVideo(url, name: "Test", sourcePage: "http://youtube.com", folder: nil)
    
        DownloadManager.sharedInstance.downloadVideo(url, name: "Otro texto. Este espero que tenga al menos dos líneas", sourcePage: "http://youtube.com", folder: nil)
      //  DownloadManager.sharedInstance.downloadVideo(url, name: "Test", sourcePage: "http://youtube.com", folder: nil)
    }

}

