//
//  TableViewController.swift
//  Top100
//
//  Created by ninja on 2/19/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, NSXMLParserDelegate {
    
    var myFeed : NSArray = []
    var url: NSURL = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        // Set feed url
        var url = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=10/xml")!
        // Call custom function.
        loadRss(url)

        
    }
    
        
    func loadRss(data: NSURL) {
        // XmlParserManager instance
        var myParser : XmlParserManager = XmlParserManager.alloc().initWithURL(data) as XmlParserManager
        // Put feed in array
        myFeed = myParser.feeds
        tableView.reloadData()
    }


    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
       if segue.identifier == "playSong" {
            
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            //let selectedFeedURL: String = feeds[indexPath.row].objectForKey("link") as String
            
            // Instance of our feedpageviewcontrolelr
            //let fpvc: FeedPageViewController = segue.destinationViewController as FeedPageViewController
            
            //fpvc.selectedFeedTitle = selectedFTitle
            //fpvc.selectedFeedFeedContent = selectedFContent
            //fpvc.selectedFeedURL = selectedFURL
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return myFeed.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        // Feeds dictionary.
        var dict : NSDictionary! = myFeed.objectAtIndex(indexPath.row) as NSDictionary
        
        // Set cell properties.
    //cell.SongTitle.numberOfLines = 3
        cell.SongTitle.text = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String
        var urlString = myFeed.objectAtIndex(indexPath.row).objectForKey("image") as? String
       
        var url = NSURL(string: urlString!)
        var image: UIImage?
        var request: NSURLRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            image = UIImage(data: data)
            cell.SongImg.image = image
        })
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("playSong", sender: self)

    }
    
}
