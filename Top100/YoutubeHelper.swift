//
//  YoutubeHelper.swift
//  Top100
//
//  Created by ninja on 3/5/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import Foundation


class YoutubeHelper: NSObject {
    class var apiKey: NSString { return "AIzaSyAoju6sWpya1U54gBOmUE-CZhjD-vwrKzU" }
     //func encode the title and return the search url
    class func encodeTitle(title:NSString)->NSString{
        //get video ID on youtube
        var originalString = title
        var escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(
            .URLQueryAllowedCharacterSet())
        var url = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=\(escapedString!)&type=video&videoCaption=any&videoCategoryId=10&key=\(apiKey)"
        return url
    }
    //func get videoID on Youtube
    class func getVideoIDFromYoutube(Url: NSString,  completionClosure: (VideoID: NSString) -> ()){
        var result = NSString()
        let url: NSURL = NSURL(string:Url)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            
            if error != nil {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            /*  doesn't need this
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers,  error: &err) as NSDictionary
            if err != nil {
            // If there is an error parsing JSON, print it to the console
            println("JSON Error \(err!.localizedDescription)")
            }*/
            
            let json = JSON(data: data)
            //get video ID from json
            if let vidID = json["items"][0]["id"]["videoId"].stringValue as NSString? {
                println("https://www.youtube.com/watch?v=\(vidID)")
                completionClosure(VideoID: vidID)

            }
        })
        task.resume()
    }
    

}