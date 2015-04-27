//
//  FavoritesViewController.swift
//  Top100
//
//  Created by ninja on 4/25/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import Foundation


import UIKit


class FavoritesViewController: UITableViewController {
    var mylist : NSMutableArray = []
    let model = Model.sharedInstance()
    //function to delete a song on database
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "playSong" {
            var indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow()!
            
            let selectedTitle: String = mylist[indexPath.row].objectForKey("title") as String
            let selectedPicLink: String = mylist[indexPath.row].objectForKey("image") as String
            // Instance of DetailViewController
            let detailVC = segue.destinationViewController as DetailViewController
            detailVC.Title = selectedTitle
            detailVC.PicLink = selectedPicLink
            detailVC.index = indexPath.row
            detailVC.parentVC = "FavoritesViewController"
        }
    }
    
    override func viewWillAppear(animated: Bool){
        //get songs from database
        model.getAllSongs(){result in
            self.mylist = result
            NSOperationQueue.mainQueue().addOperationWithBlock() { () in
                self.tableView.reloadData()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 70
        //set title
        self.navigationItem.title = "Favorites"
    }
    
    //need the following 2 methods for swipe to delete
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from array and updating the tableview)
            var SongID = mylist.objectAtIndex(indexPath.row).objectForKey("SongID") as String
            
            tableView.beginUpdates()
            mylist.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
            //update database
            model.deleteSong(SongID)
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
        return mylist.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as TableViewCell
        
        cell.SongTitle.text = mylist.objectAtIndex(indexPath.row).objectForKey("title") as? String
        cell.SongID = mylist.objectAtIndex(indexPath.row).objectForKey("SongID") as String
        
        var urlString = mylist.objectAtIndex(indexPath.row).objectForKey("image") as? String
        
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
