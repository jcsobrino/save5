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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
      
        
        LookAndFeel();
        
        
        
       // downloadTest()
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    
    
    
    func downloadTest(){
        
        var video1 = NSURL(string:"http://r5---sn-w511uxa-cjol.googlevideo.com/videoplayback?sver=3&ip=37.133.85.195&key=yt5&expire=1423238539&initcwndbps=1162500&source=youtube&id=o-AAmOogpI65WH8ynmcZz9XxBm0abHKb2er4mGDAFvU1Rn&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&el=watch&ipbits=0&upn=-_-JxatBSGU&signature=87857AEDE70E5E6D3AAC61E186626DE11E4C573C.A0EC588F5234BEFA5FD0609FA1306FF58FF6A97B&dnc=1&yms=jlge2jtu-g4&itag=18&pl=22&app=youtube_mobile&fexp=907263%2C927622%2C930676%2C9406104%2C9406485%2C943917%2C947225%2C948124%2C952302%2C952605%2C952612%2C952901%2C955301%2C957201%2C959701&ratebypass=yes&mm=31&mv=m&mt=1423216839&ms=au&cpn=4bWGxHmusQEP_wj6&ptk=youtube_multi&oid=ghgcd_xPPR_URSW5U_cwtQ.TsT5ztlcfu8EsWy2ztsauA.4dOQzkkEMJNCYo3NvbMU0w.uI4xbVg9HpiLJYr01T0REQ.vk4QB2WZXzEBs2lFNB4Gcw.8Td-asijjguOS4RL5HexHg&pltype=contentugc&c=MWEB&cver=html5")!
        
        DownloadManager.sharedInstance.downloadVideo(video1, name: "Madonna - Super Bowl Medley 2012 (HD)")
    
        var video2 = NSURL(string:"http://r2---sn-w511uxa-cjoe.googlevideo.com/videoplayback?initcwndbps=1230000&mm=31&id=o-AOhw_En_kKiXY1PTrQ3uQYUXVpzv4tkyUz0-2782iDaC&mv=m&mt=1423217124&ms=au&signature=98CD9F8D4F07C322AA1246FF7820FFBDE4762438.7562F5195B4B848D019316A9F3BCB0C9DEB3796B&ip=37.133.85.195&source=youtube&expire=1423238794&fexp=907263%2C927622%2C930676%2C9406104%2C9406485%2C943917%2C947225%2C948124%2C952302%2C952605%2C952612%2C952901%2C955301%2C957201%2C959701&key=yt5&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&sver=3&ratebypass=yes&app=youtube_mobile&itag=18&dnc=1&el=watch&yms=jlge2jtu-g4&pl=22&upn=nhL2TNusei8&ipbits=0&cpn=sK036wLkuoHFmPUQ&ptk=FullScreen&oid=Cy8DuulTcwc7ci4zPWrKiw&ptchn=sTcErHg8oDvUnTzoqsYeNw&pltype=content&c=MWEB&cver=html5")!
        
        DownloadManager.sharedInstance.downloadVideo(video2, name: "iphone 6 trailer - iphone 6 PLUS trailer official apple - iphone 6 official video by apple")
    
    
        var video3 = NSURL(string:"http://r6---sn-w511uxa-cjoe.googlevideo.com/videoplayback?source=youtube&initcwndbps=1241250&yms=jlge2jtu-g4&fexp=907263%2C927622%2C930676%2C9406104%2C9406485%2C943917%2C947225%2C948124%2C952302%2C952605%2C952612%2C952901%2C955301%2C957201%2C959701&expire=1423239037&mm=31&el=watch&itag=18&signature=B3F26744FD4E9566B431B22231E0DBEF24DF9B01.B2E36E76CAABBD7A22546313BA5F04E954C5B66F&ms=au&mt=1423217404&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&mv=m&id=o-ALhwwLLrJxRJXCmdRWunomPwRiMpSjNE8SyXhUNMU3cS&pl=22&sver=3&app=youtube_mobile&ip=37.133.85.195&key=yt5&ipbits=0&dnc=1&ratebypass=yes&upn=jLD5lfmpidQ&cpn=AR5dsr-Psq8TFKl_&ptk=Collab_affiliate&oid=kiBt15zf4kzmiSOR_xe1yA&ptchn=Ky3MG7_If9KlVuvw3rPMfw&pltype=content&c=MWEB&cver=html5")!
       
        DownloadManager.sharedInstance.downloadVideo(video3, name: "Funny Cats Compilation 60 min - NEW in HD 2014")
        
        
    }

}

