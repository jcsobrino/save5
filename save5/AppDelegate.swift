//
//  AppDelegate.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

let log = XCGLogger.defaultInstance()
let deviceSize = SDiPhoneVersion.deviceSize()

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ch : (() -> ())!
    
    var mask: CALayer?
    var initViewController: UIViewController!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
      
        log.setup(logLevel: .Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        
        LookAndFeel.sharedInstance
        FolderDAO.sharedInstance.getDefaultFolder()
        
        application.statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        
        CJPAdController.sharedInstance().adNetworks = [1]
        CJPAdController.sharedInstance().adPosition = CJPAdPosition.Bottom
        CJPAdController.sharedInstance().initialDelay = 2.0
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        initViewController = storyBoard.instantiateViewControllerWithIdentifier("InitViewController") as UIViewController
        
        
        CJPAdController.sharedInstance().startWithViewController(initViewController)
        self.window!.rootViewController = CJPAdController.sharedInstance()
       
        
        //----
        
        let aux = FAKIonIcons.chatboxIconWithSize(CGFloat(52))
        
        aux.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        
        aux.drawingPositionAdjustment = UIOffsetMake(1, 2);
        
        self.mask = CALayer()
        self.mask!.contents = aux.imageWithSize(CGSize(width: 52,height: 52)).CGImage
        self.mask!.bounds = CGRect(x: 0, y: 0, width: 105, height: 105)
        self.mask!.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.mask!.position = CGPoint(x: self.window!.frame.size.width/2, y: self.window!.frame.size.height/2)
        initViewController?.view.layer.mask = mask
        
        animateMask()
        
        self.window!.backgroundColor = UIColor(red: 80/255, green: 190/255, blue: 57/255, alpha: 1)
        self.window!.makeKeyAndVisible()
        //UIApplication.sharedApplication().statusBarHidden = true
        //------

       
        
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
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
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
    
    func animateMask() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.delegate = self
        keyFrameAnimation.duration = 1
        keyFrameAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue(CGRect: mask!.bounds)
        let secondBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 80, height: 80))
        let finalBounds = NSValue(CGRect: CGRect(x: 0, y: 0, width: 1500, height: 1500))
        keyFrameAnimation.values = [initalBounds, secondBounds, finalBounds]
        keyFrameAnimation.keyTimes = [0, 0.3, 1.0]
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
        self.mask!.addAnimation(keyFrameAnimation, forKey: "bounds")
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        initViewController?.view.layer.mask = nil //remove mask when animation completes
    }
    

    func prepareDataTest(){
       
    
        var folderNames = ["Documentaries", "Video Blog" , "Series", "Music", "TV Sports", "Z-Pieces"]
        
        if(true) {
    
        
        for folder in folderNames {
            
            
            FolderDAO.sharedInstance.createFolder(folder)
            
        }
        }
    
        var folders = FolderDAO.sharedInstance.findAll() as [Folder]
       
        if(true) {
            
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r5---sn-w511uxa-cjol.googlevideo.com/videoplayback?el=watch&id=o-ANRvVkRkXMmsE5KO-YAX2-8JyMAi43Zjd_E417YG-se-&mm=31&upn=DP42oeuQi1w&key=yt5&ip=37.133.85.201&ms=au&mt=1426853184&mv=m&ipbits=0&initcwndbps=1280000&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&signature=7E10FF24843BA487D381067686B9A9C8D270CC77.92FCF55EFDB113D6BB2B3BD26AABAFA11251A7C5&ratebypass=yes&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&sver=3&expire=1426874857&app=youtube_mobile&yms=YqdC6oD29e4&pl=22&itag=18&dnc=1&source=youtube&cpn=jkpjoQyvG6Au-dot&ptk=lFnEBUhc1o6xAEc6JrfoEw&oid=NovocfL5ml3Spsf8NrnNbA&ptchn=C9h3H-sGrvqd2otknZntsQ&pltype=content&c=MWEB&cver=html5")!, name: "Bunny's birthday", sourcePage: "http://cartoonsandcats.info", folder: folders[4])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r5---sn-w511uxa-cjol.googlevideo.com/videoplayback?el=watch&id=o-ANRvVkRkXMmsE5KO-YAX2-8JyMAi43Zjd_E417YG-se-&mm=31&upn=DP42oeuQi1w&key=yt5&ip=37.133.85.201&ms=au&mt=1426853184&mv=m&ipbits=0&initcwndbps=1280000&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&signature=7E10FF24843BA487D381067686B9A9C8D270CC77.92FCF55EFDB113D6BB2B3BD26AABAFA11251A7C5&ratebypass=yes&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&sver=3&expire=1426874857&app=youtube_mobile&yms=YqdC6oD29e4&pl=22&itag=18&dnc=1&source=youtube&cpn=jkpjoQyvG6Au-dot&ptk=lFnEBUhc1o6xAEc6JrfoEw&oid=NovocfL5ml3Spsf8NrnNbA&ptchn=C9h3H-sGrvqd2otknZntsQ&pltype=content&c=MWEB&cver=html5")!, name: "Bunny's birthday", sourcePage: "http://cartoonsandcats.info", folder: folders[4])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r5---sn-w511uxa-cjol.googlevideo.com/videoplayback?el=watch&id=o-ANRvVkRkXMmsE5KO-YAX2-8JyMAi43Zjd_E417YG-se-&mm=31&upn=DP42oeuQi1w&key=yt5&ip=37.133.85.201&ms=au&mt=1426853184&mv=m&ipbits=0&initcwndbps=1280000&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&signature=7E10FF24843BA487D381067686B9A9C8D270CC77.92FCF55EFDB113D6BB2B3BD26AABAFA11251A7C5&ratebypass=yes&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&sver=3&expire=1426874857&app=youtube_mobile&yms=YqdC6oD29e4&pl=22&itag=18&dnc=1&source=youtube&cpn=jkpjoQyvG6Au-dot&ptk=lFnEBUhc1o6xAEc6JrfoEw&oid=NovocfL5ml3Spsf8NrnNbA&ptchn=C9h3H-sGrvqd2otknZntsQ&pltype=content&c=MWEB&cver=html5")!, name: "Bunny's birthday", sourcePage: "http://cartoonsandcats.info", folder: folders[4])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r5---sn-w511uxa-cjol.googlevideo.com/videoplayback?el=watch&id=o-ANRvVkRkXMmsE5KO-YAX2-8JyMAi43Zjd_E417YG-se-&mm=31&upn=DP42oeuQi1w&key=yt5&ip=37.133.85.201&ms=au&mt=1426853184&mv=m&ipbits=0&initcwndbps=1280000&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&signature=7E10FF24843BA487D381067686B9A9C8D270CC77.92FCF55EFDB113D6BB2B3BD26AABAFA11251A7C5&ratebypass=yes&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&sver=3&expire=1426874857&app=youtube_mobile&yms=YqdC6oD29e4&pl=22&itag=18&dnc=1&source=youtube&cpn=jkpjoQyvG6Au-dot&ptk=lFnEBUhc1o6xAEc6JrfoEw&oid=NovocfL5ml3Spsf8NrnNbA&ptchn=C9h3H-sGrvqd2otknZntsQ&pltype=content&c=MWEB&cver=html5")!, name: "Bunny's birthday", sourcePage: "http://cartoonsandcats.info", folder: folders[4])
            
            
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r1---sn-w511uxa-cjoe.googlevideo.com/videoplayback?sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&id=o-AGDjh8zJpqJD3D7ZvliJasgV_Mt9klrav_uNCTVWjpS6&mv=m&mt=1426852259&ms=au&itag=18&initcwndbps=1357500&mm=31&ipbits=0&pl=22&yms=dJKjt8KGK2c&expire=1426873930&ratebypass=yes&upn=HUsXYlo8GPU&dnc=1&source=youtube&signature=046E656AE3DF27685E520C3B9D053D83AF0F9BFE.7A3E54DF0B7FF10EEC3E1B0F6191FDB57390B89C&sver=3&key=yt5&app=youtube_mobile&el=watch&ip=37.133.85.201&cpn=4pm0e0nZ1kB8klnq&ptk=WarnerMC&oid=yfdyTRzMmu3FPmmTBoa5Wg&pltype=contentugc&c=MWEB&cver=html5")!,name: "Bunny's birthday", sourcePage: "http://www.test.com", folder: folders[6])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r1---sn-w511uxa-cjoe.googlevideo.com/videoplayback?sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&id=o-AGDjh8zJpqJD3D7ZvliJasgV_Mt9klrav_uNCTVWjpS6&mv=m&mt=1426852259&ms=au&itag=18&initcwndbps=1357500&mm=31&ipbits=0&pl=22&yms=dJKjt8KGK2c&expire=1426873930&ratebypass=yes&upn=HUsXYlo8GPU&dnc=1&source=youtube&signature=046E656AE3DF27685E520C3B9D053D83AF0F9BFE.7A3E54DF0B7FF10EEC3E1B0F6191FDB57390B89C&sver=3&key=yt5&app=youtube_mobile&el=watch&ip=37.133.85.201&cpn=4pm0e0nZ1kB8klnq&ptk=WarnerMC&oid=yfdyTRzMmu3FPmmTBoa5Wg&pltype=contentugc&c=MWEB&cver=html5")!,name: "Bunny's birthday", sourcePage: "http://www.test.com", folder: folders[6])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r1---sn-w511uxa-cjoe.googlevideo.com/videoplayback?sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&id=o-AGDjh8zJpqJD3D7ZvliJasgV_Mt9klrav_uNCTVWjpS6&mv=m&mt=1426852259&ms=au&itag=18&initcwndbps=1357500&mm=31&ipbits=0&pl=22&yms=dJKjt8KGK2c&expire=1426873930&ratebypass=yes&upn=HUsXYlo8GPU&dnc=1&source=youtube&signature=046E656AE3DF27685E520C3B9D053D83AF0F9BFE.7A3E54DF0B7FF10EEC3E1B0F6191FDB57390B89C&sver=3&key=yt5&app=youtube_mobile&el=watch&ip=37.133.85.201&cpn=4pm0e0nZ1kB8klnq&ptk=WarnerMC&oid=yfdyTRzMmu3FPmmTBoa5Wg&pltype=contentugc&c=MWEB&cver=html5")!,name: "Bunny's birthday", sourcePage: "http://www.test.com", folder: folders[6])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r7---sn-w511uxa-cjol.googlevideo.com/videoplayback?pl=22&itag=18&el=watch&yms=HNlyDF3JNyI&source=youtube&upn=gnNvxay0GEo&id=o-ABv5bNaW3QbRjDlZJc596lliP2BrIPoUjXyd8SORwgFr&mm=31&ip=37.133.85.201&ms=au&mt=1426853938&gcr=es&sparams=gcr%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&signature=E18EFF56DCC438464F96EA8D7883AF739B939825.DBF85B82268A1C3F3882E5012E25C73B3BA3E33F&ratebypass=yes&fexp=900720%2C902904%2C907263%2C910100%2C933119%2C934954%2C9405136%2C9405981%2C9406535%2C9406653%2C9406910%2C9407103%2C9408101%2C942311%2C945084%2C945103%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C953919%2C955301%2C957201%2C959701%2C961404&initcwndbps=1261250&key=yt5&sver=3&ipbits=0&expire=1426875677&mv=m&app=youtube_mobile&dnc=1&cpn=N1dAnpLwF_GAQBaN&ptk=youtube_multi&oid=YbGWGCIUCoaUePqGy_acMw.TsT5ztlcfu8EsWy2ztsauA&pltype=contentugc&c=MWEB&cver=html5")!, name: "Madonna Performance Ghosttown on The Ellen Degeneres Show", sourcePage: "http://music.isyourfriend.com", folder: folders[5])
            
            
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://www.w3schools.com/html/mov_bbb.mp4")!, name: "Bunny's birthday and friends", sourcePage: "http://cartoonsandcats.info", folder: folders[0])
            
             DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://www.w3schools.com/html/mov_bbb.mp4")!, name: "Bunny's birthday and friends", sourcePage: "http://cartoonsandcats.info", folder: folders[0])
            
             DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://www.w3schools.com/html/mov_bbb.mp4")!, name: "Bunny's birthday and friends", sourcePage: "http://cartoonsandcats.info", folder: folders[0])
        
               
  
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r3---sn-w511uxa-cjoe.googlevideo.com/videoplayback?ratebypass=yes&ipbits=0&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&expire=1426873747&dnc=1&yms=dJKjt8KGK2c&mt=1426852035&initcwndbps=1378750&mm=31&signature=8D39C6406BE3069A74DE5B328EF22595244FE95A.3E21987D0B67491844982B9B9714FF453EFE79BE&key=yt5&ip=37.133.85.201&pl=22&source=youtube&sver=3&app=youtube_mobile&mv=m&el=watch&ms=au&id=o-ALlDdQUflqj_Us-eoXoEgZQtBT3NVLSHqDG-u0ssElwz&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&itag=18&upn=FekGk1rjby8&cpn=LE6a8Di4ALIumBeK&ptk=warnerbros_vfp&oid=Ai8XQN5VD_3y-bgl_8M87w&pltype=contentugc&c=MWEB&cver=html5")!, name: "Tom and Jerry cartoons!", sourcePage: "http://cartoonsandcats.info", folder: folders[2])
            
             DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r3---sn-w511uxa-cjoe.googlevideo.com/videoplayback?ratebypass=yes&ipbits=0&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&expire=1426873747&dnc=1&yms=dJKjt8KGK2c&mt=1426852035&initcwndbps=1378750&mm=31&signature=8D39C6406BE3069A74DE5B328EF22595244FE95A.3E21987D0B67491844982B9B9714FF453EFE79BE&key=yt5&ip=37.133.85.201&pl=22&source=youtube&sver=3&app=youtube_mobile&mv=m&el=watch&ms=au&id=o-ALlDdQUflqj_Us-eoXoEgZQtBT3NVLSHqDG-u0ssElwz&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&itag=18&upn=FekGk1rjby8&cpn=LE6a8Di4ALIumBeK&ptk=warnerbros_vfp&oid=Ai8XQN5VD_3y-bgl_8M87w&pltype=contentugc&c=MWEB&cver=html5")!, name: "Tom and Jerry cartoons!", sourcePage: "http://cartoonsandcats.info", folder: folders[2])
            
             DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r3---sn-w511uxa-cjoe.googlevideo.com/videoplayback?ratebypass=yes&ipbits=0&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&expire=1426873747&dnc=1&yms=dJKjt8KGK2c&mt=1426852035&initcwndbps=1378750&mm=31&signature=8D39C6406BE3069A74DE5B328EF22595244FE95A.3E21987D0B67491844982B9B9714FF453EFE79BE&key=yt5&ip=37.133.85.201&pl=22&source=youtube&sver=3&app=youtube_mobile&mv=m&el=watch&ms=au&id=o-ALlDdQUflqj_Us-eoXoEgZQtBT3NVLSHqDG-u0ssElwz&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&itag=18&upn=FekGk1rjby8&cpn=LE6a8Di4ALIumBeK&ptk=warnerbros_vfp&oid=Ai8XQN5VD_3y-bgl_8M87w&pltype=contentugc&c=MWEB&cver=html5")!, name: "Tom and Jerry cartoons!", sourcePage: "http://cartoonsandcats.info", folder: folders[2])
        
        
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/2386418/video")!, name: "Bunny's birthday", sourcePage: "http://freevideos.com", folder: folders[3])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/2386418/video")!, name: "Bunny's birthday", sourcePage: "http://freevideos.com", folder: folders[3])
            
            DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/2386418/video")!, name: "Bunny's birthday", sourcePage: "http://freevideos.com", folder: folders[3])
        
        
        
        }
        
        
       
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/1492531/video")!, name: "People works too much. Doctors recommend to sleep more", sourcePage: "http://allnews.world.com", folder: folders[1])

        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r6---sn-w511uxa-cjoe.googlevideo.com/videoplayback?gcr=es&el=watch&id=o-AOv5tbmK17HHRjHDc8g88yWyXvCPRBegrZYyFx_yNGC8&mm=31&upn=2kFxBH20udI&key=yt5&ip=37.133.85.201&ms=au&mt=1426854184&mv=m&ipbits=0&initcwndbps=1272500&fexp=900720%2C902904%2C907263%2C910100%2C933119%2C934954%2C9405136%2C9405981%2C9406535%2C9406653%2C9406910%2C9407103%2C9408101%2C942311%2C945084%2C945103%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C953919%2C955301%2C957201%2C959701%2C961404&signature=0E6630FDEA39F433D88E7C5DA71A1198755D5697.7E9084A4521C6B385EED089708EAB1A009DE098F&ratebypass=yes&sparams=gcr%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&sver=3&expire=1426875814&app=youtube_mobile&yms=HNlyDF3JNyI&pl=22&itag=18&dnc=1&source=youtube&cpn=e_129xsu6aNYe1we&ptk=vevostandard&oid=hl7nsjVSXUZ-DkUDq4miuA&ptchn=2kTZB_yeYgdAg4wP2tEryA&pltype=content&c=MWEB&cver=html5")!, name: "Tom and Jerry cartoons!", sourcePage: "http://cartoonsandcats.info", folder: folders[1])

        
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r3---sn-w511uxa-cjoe.googlevideo.com/videoplayback?signature=25242D3F504F91E5AA7F9136D9DE1D74B1DE7E38.19F475EE872623D95F35144D84F58AC6EE2C67B1&el=watch&mv=m&pl=22&ms=au&mm=31&key=yt5&sver=3&mt=1426853041&yms=YqdC6oD29e4&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&app=youtube_mobile&expire=1426874685&initcwndbps=1313750&ipbits=0&ratebypass=yes&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&upn=CqAKV5pQ1JU&source=youtube&id=o-AKyAV7K4K35Zq1iVjOI0LpQOfACmZruOlotA2OLPpt4V&itag=18&dnc=1&ip=37.133.85.201&cpn=1jZ8i3oAkmEnAd3V&ptk=thegamestation&oid=LXruUYJFkVEM_5Wkyw42-Q&ptchn=9CuvdOVfMPvKCiwdGKL3cQ&pltype=content&c=MWEB&cver=html5")!, name: "Super Mario World - Joshi Time", sourcePage: "http://music.isyourfriend.com", folder: folders[1])

              DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r8---sn-w511uxa-cjoe.googlevideo.com/videoplayback?pl=22&source=youtube&key=yt5&expire=1426874973&upn=MU-HnlSjpf0&sver=3&ip=37.133.85.201&app=youtube_mobile&mv=m&mt=1426853315&ms=au&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&mm=31&ipbits=0&id=o-ABpKFA8DAASTs2F42_TTFCD_r70vaXY53gVjVwOhrvW6&yms=YqdC6oD29e4&dnc=1&initcwndbps=1257500&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&el=watch&itag=18&signature=2071C7623506112A224C24DB099FE61D7B193900.D8E79D067DDABFDFB5C73D5115829C9DB47A14DC&ratebypass=yes&cpn=RGvBuUedoEMKObQt&ptk=youtube_none&pltype=contentugc&c=MWEB&cver=html5")!, name: "Video promotion for the Matrox Mystique (1997)", sourcePage: "http://music.isyourfriend.com", folder: folders[1])
        
        
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/1110432/video")!, name: "I can't believe they invented it!", sourcePage: "http://peoplefinder.org", folder: folders[1])
        
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/1110413/video")!, name: "Bunny's birthday and friends", sourcePage: "http://working.alltime.biz", folder: folders[1])
        
        
    }
    
    
    func prepareDownloadData(){
    
        
        
        Async.background{
        
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://www.w3schools.com/html/mov_bbb.mp4")!, name: "Bunny's birthday and friends", sourcePage: "http://cartoonsandcats.info", folder: FolderDAO.sharedInstance.getDefaultFolder())
            
          
        DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r1---sn-w511uxa-cjoe.googlevideo.com/videoplayback?sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&fexp=900222%2C900720%2C907263%2C930825%2C934954%2C936121%2C9405136%2C9405981%2C9406819%2C9406829%2C9407103%2C9407819%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404%2C964712&id=o-AGDjh8zJpqJD3D7ZvliJasgV_Mt9klrav_uNCTVWjpS6&mv=m&mt=1426852259&ms=au&itag=18&initcwndbps=1357500&mm=31&ipbits=0&pl=22&yms=dJKjt8KGK2c&expire=1426873930&ratebypass=yes&upn=HUsXYlo8GPU&dnc=1&source=youtube&signature=046E656AE3DF27685E520C3B9D053D83AF0F9BFE.7A3E54DF0B7FF10EEC3E1B0F6191FDB57390B89C&sver=3&key=yt5&app=youtube_mobile&el=watch&ip=37.133.85.201&cpn=4pm0e0nZ1kB8klnq&ptk=WarnerMC&oid=yfdyTRzMmu3FPmmTBoa5Wg&pltype=contentugc&c=MWEB&cver=html5")!,name: "Apple iPhone 6 vs iPhone 6 Plus Dual Unboxing and Comparison (128GB and 64GB)", sourcePage: "http://allaboutapple.world.com", folder: FolderDAO.sharedInstance.getDefaultFolder())
        
        
         DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://r8---sn-w511uxa-cjoe.googlevideo.com/videoplayback?pl=22&source=youtube&key=yt5&expire=1426874973&upn=MU-HnlSjpf0&sver=3&ip=37.133.85.201&app=youtube_mobile&mv=m&mt=1426853315&ms=au&fexp=900720%2C907263%2C934954%2C9405135%2C9406614%2C9406731%2C9407103%2C9408101%2C948124%2C951511%2C951703%2C952302%2C952612%2C952901%2C955301%2C957201%2C959701%2C961404&mm=31&ipbits=0&id=o-ABpKFA8DAASTs2F42_TTFCD_r70vaXY53gVjVwOhrvW6&yms=YqdC6oD29e4&dnc=1&initcwndbps=1257500&sparams=id%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Cmm%2Cms%2Cmv%2Cpl%2Cratebypass%2Csource%2Cupn%2Cexpire&el=watch&itag=18&signature=2071C7623506112A224C24DB099FE61D7B193900.D8E79D067DDABFDFB5C73D5115829C9DB47A14DC&ratebypass=yes&cpn=RGvBuUedoEMKObQt&ptk=youtube_none&pltype=contentugc&c=MWEB&cver=html5")!,name: "Sunshine Superman Official Trailer 1 (2015) - Documentary HD", sourcePage: "http://bestdocumentaries.org", folder: FolderDAO.sharedInstance.getDefaultFolder())
        
        
        
        
        
             DownloadManager.sharedInstance.downloadVideo(NSURL(string: "http://view.vzaar.com/1492531/video")!, name: "Armin van Buuren Live at Tomorrowland - Best performance ever! (Full Set)", sourcePage: "http://videosandmusic.europe.com", folder: FolderDAO.sharedInstance.getDefaultFolder())
        
        }
    }
    
    
}

