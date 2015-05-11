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
    private var data : NSArray = []
    
    public class func sharedInstance() -> Model {
        return _ModelSharedInstance
    }
    
    public func setData(feeds:NSArray){
        data = feeds;
    }
    
    public func getItem(index: Int) -> (NSDictionary) {
        return data.objectAtIndex(index) as (NSDictionary)
    }
    
    private func sendRequest(data : String, url : NSURL){
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
        //post the request in a separate thread
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),
            completionHandler: { (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void  in
                if let output = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    println(output)
                }
        })
    }
    
    //function to insert a song to database
    public func addSong(Pic:String, Title:String){
        var bodyData = "Pic=\(Pic)&Title=\(Title)"
        var url = NSURL(string: "http://104.236.43.114/top100/insert.php")
        sendRequest(bodyData, url: url!)
    }
    
    //function to delete a song to database
    public func deleteSong(SongID:String){
        var bodyData = "SongID=\(SongID)"
        var url = NSURL(string: "http://104.236.43.114/top100/delete.php")
        sendRequest(bodyData, url: url!)
    }
    
    //function to create an array of songs from json data
    private func createSongArrayFromJson(json : JSON) -> NSMutableArray{
        var Array : NSMutableArray = []
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
        return Array
    }
    
    //function to get all songs from database
    public func getAllSongs(completionClosure: (result: NSMutableArray)->())
    {
        var Array : NSMutableArray = []
        var result = NSString()
        let url = NSURL(string: "http://104.236.43.114/top100/getAll.php")
        let session = NSURLSession.sharedSession()
        //send request in a separate thread
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            let json = JSON(data: data)
            //get song title and picture from json
            //println(json)
            Array = self.createSongArrayFromJson(json)
            completionClosure(result: Array)
        })
        task.resume()
    }
}

let _ModelSharedInstance: Model = { Model() }()
