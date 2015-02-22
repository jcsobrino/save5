//
//  WebBrowserRecentSearchesViewController.swift
//  save5
//
//  Created by José Carlos Sobrino on 22/02/15.
//  Copyright (c) 2015 José Carlos Sobrino. All rights reserved.
//

import UIKit

class WebBrowserRecentSearchesViewController: UITableViewController, UISearchResultsUpdating, NSXMLParserDelegate {

    let cellIndentifier = "RecentSearchTableViewCell"
    
    var allSearches: [(String, String)] = []
    var currentResults: [(String, String)] = []
    var googleSuggestions: [String] = []
    var lookup:WebSearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? currentResults.count : googleSuggestions.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if(section == 0){
            
            return currentResults.isEmpty ? nil : "Recent Searches"
        }
        
        return "Google Suggestions"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIndentifier, forIndexPath: indexPath) as RecentSearchTableViewCell
        
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    func configureCell(cell: RecentSearchTableViewCell, indexPath:NSIndexPath) {
        
        if(indexPath.section == 0) {
        
            cell.title.text = currentResults[indexPath.row].0
            cell.URL.text = currentResults[indexPath.row].1
        
        } else {
            
            cell.title.text = ""
            cell.URL.text = googleSuggestions[indexPath.row]
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        lookup!.searchBar!.text = (indexPath.section == 0 ? currentResults[indexPath.row].1 : googleSuggestions[indexPath.row])
        lookup?.searchBarSearchButtonClicked(lookup!.searchBar!)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let textSearchBar = searchController.searchBar.text
        
        if (!searchController.active){
            
            return
        }
        
        //recent searches
        if(textSearchBar.isEmpty){
            
            currentResults = allSearches
            
        } else {
        
            currentResults = allSearches.filter{($0.0 as NSString).containsString(textSearchBar) || ($0.1 as NSString).containsString(textSearchBar)}
        }
        
        //google searches
       
        googleSuggestions.removeAll(keepCapacity: false)
        let dataGoogleSuggestions = invokeGoogleService(textSearchBar)
        let xmlGoogleSuggestions = NSDictionary(XMLData: dataGoogleSuggestions)
        
        if(xmlGoogleSuggestions != nil) {
        
            let suggestionsAux = xmlGoogleSuggestions.arrayValueForKeyPath("CompleteSuggestion.suggestion._data")?.filter({
                
                if let aux = $0 as? String {
                    return  true
                }
            
                return false
            })
            
            if(suggestionsAux != nil) {
            
                //println(suggestionsAux)
            
                googleSuggestions = suggestionsAux as [String]
            }
            
        }
        
        tableView.reloadData()
    }
    
    func addRecentSearch(newTitle: String, newURL: String) {
        
        for (title, URL) in allSearches {
            
            if(URL == newURL){
                
                return
            }
            
        }
        
        allSearches.append((newTitle, newURL))
    }


    private func invokeGoogleService(query: String) -> NSData {
        
        var urlPath = "http://suggestqueries.google.com/complete/search?output=toolbar&hl=es&q=\(query.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)"
        var url: NSURL = NSURL(string: urlPath)!
        var request: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: AutoreleasingUnsafeMutablePointer<NSErrorPointer?> = nil
        
        
        var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)
        
        return dataVal!
    }
}
