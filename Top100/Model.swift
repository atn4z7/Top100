//
//  Model.swift
//  Top100
//
//  Created by ninja on 4/3/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import Foundation

//class responsible for storing and retrieving video info
class Model  {
    var data : NSArray = []
    
    class func sharedInstance() -> Model {
        return _ModelSharedInstance
    }
    
    func setData(feeds:NSArray){
        data = feeds;
    }
    func getItem(index: Int) -> (NSDictionary) {
        return data.objectAtIndex(index) as (NSDictionary)
    }
    //function to insert a song to database
    func addSong(Pic:String, Title:String){
        var bodyData = "Pic=\(Pic)&Title=\(Title)"
        var URL = NSURL(string: "http://104.236.43.114/top100/insert.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void  in
                if let output = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    println(output)
                }
        })
    }

    func deleteSong(SongID:String){
        var bodyData = "SongID=\(SongID)"
        var URL = NSURL(string: "http://104.236.43.114/top100/delete.php")
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
        completionHandler: { (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void  in
        if let output = NSString(data: data, encoding: NSUTF8StringEncoding) {
        println(output)
        }
        })
    }
    func getAllSongs(completionClosure: (result: NSMutableArray)->())
    {
        var Array : NSMutableArray = []
        var result = NSString()
        let url = NSURL(string: "http://104.236.43.114/top100/getAll.php")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            let json = JSON(data: data)
            //get song title and picture from json
            //println(json)
            for (key, subJson) in json {
                var elements = NSMutableDictionary()
                if let SongID = subJson["SongID"].string {
                    println(SongID)
                    elements.setObject(SongID, forKey: "SongID")
                    
                }
                if let title = subJson["Title"].string {
                    println(title)
                    elements.setObject(title, forKey: "title")
                    
                }
                if let image = subJson["Pic"].string {
                    println(image)
                    elements.setObject(image, forKey: "image")
                    
                }
                Array.addObject(elements)
            }
            println(Array.count)
            completionClosure(result: Array)
        })
        task.resume()
        
    }
    
}
let _ModelSharedInstance: Model = { Model() }()
