//
//  WebBrowserRecentSearchesViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 22/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit
import Foundation

class WebBrowserRecentSearchesViewController: UITableViewController, UISearchResultsUpdating {

    let maxResultsSection = 5
    let currentSearchesSection = 0
    let googleSuggestionsSection = 1
    let cellIndentifier = "RecentSearchTableViewCell"
    
    var recentSearches: [WebRecentSearchItem] = []
    var googleSuggestions: [String] = []
    var delegate: WebSearchRecentSearchesDelegate?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
 
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == currentSearchesSection ? recentSearches.count : googleSuggestions.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == currentSearchesSection) {
            
            return recentSearches.isEmpty ? nil : Utils.localizedString("Recent Searches")
        }
        
        return Utils.localizedString("Google Suggestions")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as RecentSearchTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: RecentSearchTableViewCell, indexPath:NSIndexPath) {
        
        if(indexPath.section == currentSearchesSection) {
        
            cell.title.text = recentSearches[indexPath.row].title
            cell.URL.text = recentSearches[indexPath.row].url
        
        } else {
            
            cell.title.text = nil
            cell.URL.attributedText =  Utils.createMutableAttributedString(LookAndFeel.icons.webSearchSuggestionIcon, text: googleSuggestions[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        delegate?.recentSearchSelected(self, URL: indexPath.section == currentSearchesSection ? recentSearches[indexPath.row].url : googleSuggestions[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        (view as UITableViewHeaderFooterView).backgroundView!.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if (searchController.active){
            
            let textSearchBar = searchController.searchBar.text
            
            //recent searches
            recentSearches = WebRecentSearchItemDAO.sharedInstance.findItems(textSearchBar).maxItems(maxResultsSection)
            
            //google searches
            googleSuggestions.removeAll(keepCapacity: false)
            let xmlGoogleSuggestions = NSDictionary(XMLData: invokeGoogleService(textSearchBar))
            
            if(xmlGoogleSuggestions != nil) {
                
                let suggestionsAux = xmlGoogleSuggestions.arrayValueForKeyPath("CompleteSuggestion.suggestion._data")?.filter({ return $0 is String })
                
                if(suggestionsAux != nil) {
                    
                    googleSuggestions = suggestionsAux!.maxItems(maxResultsSection) as [String]
                    
                } else {
                    
                    googleSuggestions.append(textSearchBar)
                }
                
            }
            
            tableView.reloadData()
        }
    }
    
    func addRecentSearch(title: String, url: String) {
        
        WebRecentSearchItemDAO.sharedInstance.addItem(url, title: title)
    }

    private func invokeGoogleService(query: String) -> NSData {
        
        let urlPath = "http://suggestqueries.google.com/complete/search?output=toolbar&hl=es&q=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        return NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error:nil)!
    }
    
}

@objc protocol WebSearchRecentSearchesDelegate {
    
    func recentSearchSelected (webBrowserRecentSearches: WebBrowserRecentSearchesViewController, URL:String)
}
