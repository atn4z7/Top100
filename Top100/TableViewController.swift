//
//  TableViewController.swift
//  Top100
//
//  Created by ninja on 2/19/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit


class TableViewController: UITableViewController, NSXMLParserDelegate {
    
    private var myFeed : NSArray = []
    private var url: NSURL = NSURL()
    private let model = Model.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set title
        self.navigationItem.title = "Top 100"
        
        //set tableview settings
        self.tableView.rowHeight = 70
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        //set feed url
        var url = NSURL(string: "https://itunes.apple.com/us/rss/topsongs/limit=100/xml")!
        
        //load rss for url
        loadRss(url)
    }
        
    private func loadRss(data: NSURL) {
        //get xml and parse in new thread then update ui in main thread
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            // XmlParserManager instance
            var myParser : XmlParserManager = XmlParserManager.alloc().initWithURL(data) as XmlParserManager
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                // Put feed in array
                self.myFeed = myParser.getFeeds()
                assert(self.myFeed.count > 0, "list of songs cannot have zero items")
                self.model.setData(self.myFeed)
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
       if segue.identifier == "playSong" {
            //get selected item
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let selectedTitle: String = myFeed[indexPath.row].objectForKey("title") as String
            let selectedPicLink: String = myFeed[indexPath.row].objectForKey("image") as String
        
            // Instance of DetailViewController
            let detailVC = segue.destinationViewController as DetailViewController
        
            //transfer data to new view
            detailVC.setTitle(selectedTitle)
            detailVC.setPicLink(selectedPicLink)
            detailVC.setIndex(indexPath.row)
            detailVC.setParentVC("TableViewController")
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
        if let title = myFeed.objectAtIndex(indexPath.row).objectForKey("title") as? String{
            cell.setTitle(title)
        }
        
        var urlString = myFeed.objectAtIndex(indexPath.row).objectForKey("image") as? String
       
        var url = NSURL(string: urlString!)
        var image: UIImage?
        
        //download the image for cell in a separate thread
        var request: NSURLRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
               cell.setImg(data)
        })
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("playSong", sender: self)
    }
    
}
