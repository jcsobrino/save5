//
//  InitViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 25/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class InitViewController: UITabBarController, BWWalkthroughViewControllerDelegate {

    private let webBrowserTabBarIndex = 0
    private let downloadTabBarIndex = 1
    private let storedTabBarIndex = 2
    
    private var numOfDownloadsNotSeen = 0
    private var numOfSavedVideosNotSeen = 0
    
    var cosa = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var tab1 = self.tabBar.items![webBrowserTabBarIndex] as UITabBarItem
        var tab2 = self.tabBar.items![downloadTabBarIndex] as UITabBarItem
        var tab3 = self.tabBar.items![storedTabBarIndex] as UITabBarItem
        
        let size = CGFloat(30)
        
        
        let image1 = FAKIonIcons.ios7WorldIconWithSize(size)
        
        image1.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        
        
        tab1.image = image1.imageWithSize(CGSize(width: size, height: size))
        //tab2.image = FAKIonIcons.ios7DownloadIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
        tab2.image = FAKIonIcons.archiveIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
        tab3.image = FAKIonIcons.ios7VideocamIconWithSize(size).imageWithSize(CGSize(width: size, height: size))
        
        
        
        
        tab1.title = Utils.localizedString("Find Videos")
        tab2.title = Utils.localizedString("Downloads")
        tab3.title = Utils.localizedString("Folders")

         NSNotificationCenter.defaultCenter().addObserver(self, selector: "newDownload:", name:DownloadManager.notification.newDownload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishDownload:", name:DownloadManager.notification.finishDownload, object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool){
        
       super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") || cosa {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showWalkthrough(){
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("Master") as MasterWalkthroughViewController
        let page1 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Qué es Save5",
            text: "Con Save5 podrás descargar los vídeos incrustados en páginas Web y visualizarlos posteriormente sin estar conectado a Internet. Descubre cómo hacerlo con esta breve guía",
            imageName: "saved-videos-empty-state.png")
        let page2 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Busca tus vídeos",
            text: "Utiliza el navegador Web incorporado para buscar el vídeo que quieres descargar",
            imageName: "saved-videos-empty-state.png")
        let page3 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Reproduce el vídeo",
            text: "ejecuta el vídeo durante unos segundos pulsando directamente sobre él y a continuación cierra el reproductor",
            imageName: "saved-videos-empty-state.png")
        let page4 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Elige una carpeta",
            text: "Selecciona la carpeta en la que quieres guardar el vídeo a descargar",
            imageName: "saved-videos-empty-state.png")
        let page5 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Consulta las descargas activas",
            text: "Puedes consultar las descargas activas en cada momento, así como pausarlas y reanudarlas posteriormente",
            imageName: "saved-videos-empty-state.png")
        let page6 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Organiza tus vídeos",
            text: "Organiza los vídeos descargados en carpetas y muévelos de una a otra en función de tus necesidades",
            imageName: "saved-videos-empty-state.png")
        
        let page7 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Disfruta!",
            text: "Reproduce los vídeos guardados cuado quieras y sin conexión a Internet",
            imageName: "saved-videos-empty-state.png")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page1)
        walkthrough.addViewController(page2)
        walkthrough.addViewController(page3)
        walkthrough.addViewController(page4)
        walkthrough.addViewController(page5)
        walkthrough.addViewController(page6)
        walkthrough.addViewController(page7)
         self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(pageNumber: Int) {
        println("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        cosa = false
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    

    
 
}
