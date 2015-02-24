//
//  ViewController.swift
//  BWWalkthroughExample
//
//  Created by Yari D'areglia on 17/09/14.
//  Copyright (c) 2014 Yari D'areglia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if !userDefaults.boolForKey("walkthroughPresented") || true {
            
            showWalkthrough()
            
            userDefaults.setBool(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            subtitle: "Cómo funciona",
            text: "Utiliza el navegador Web incorporado para buscar el vídeo que quieres descargar",
            imageName: "saved-videos-empty-state.png")
        let page3 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Cómo funciona",
            text: "Reproduce el vídeo durante unos segundos y a continuación cierra el reproductor",
            imageName: "saved-videos-empty-state.png")
        let page4 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Cómo funciona",
            text: "Elige la carpeta en la que quieres guardar el vídeo",
            imageName: "saved-videos-empty-state.png")
        let page5 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Cómo funciona",
            text: "Puedes consultar las descargas activas en cada momento, así como pausarlas y reanudarlas posteriormente",
            imageName: "saved-videos-empty-state.png")
        let page6 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Cómo funciona",
            text: "Organiza los vídeos descargados en carpetas y muévelos de una a otra en función de tus necesidades",
            imageName: "saved-videos-empty-state.png")
        
        let page7 = PageWalkthroughViewController(title: "Bienvenido a Save5!",
            subtitle: "Cómo funciona",
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
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

