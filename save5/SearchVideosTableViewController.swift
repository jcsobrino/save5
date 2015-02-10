//
//  SearchVideosTableViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 10/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//


import CoreData

class SearchVideosTableViewController: UITableViewController {

    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    
    var data = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "Search"

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIndentifier = "SearchVideoTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as VideoTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell:VideoTableViewCell, indexPath:NSIndexPath){
        
        Async.main {
            
            let video = self.data[indexPath.row] as Video
            let pathFile = self.documentsPath.stringByAppendingPathComponent(video.thumbnailFilename)
            
            cell.name.text = video.name
            cell.hostname.text = "youtube.com"
            cell.size.text = String(format: "%.2f MBs", video.spaceOnDisk/1024)
            cell.length.text = Utils.formatSeconds(Int(video.length))
            cell.thumbnail.image = UIImage(contentsOfFile: pathFile)
        }
    }

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        data = VideoDAO.sharedInstance.findByName(searchController.searchBar.text, sortDescriptor: nil)
        
        self.tableView!.reloadData()
    }
    
}
