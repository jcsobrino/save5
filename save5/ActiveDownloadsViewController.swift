//
//  ActiveDownloadsViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 31/01/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class ActiveDownloadsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return DownloadManager.sharedInstance.listDownloads().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIndentifier = "ActiveDownloadTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier) as ActiveDownloadTableViewCell
        let downloadTask = DownloadManager.sharedInstance.listDownloads()[indexPath.row]
        
        cell.title.text = downloadTask.video.title
        cell.author.text = downloadTask.video.author
        updateDownloadTaskCell(indexPath, downloadCell: cell)
        
        return cell
    }

}
