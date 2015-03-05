//
//  XMLParser.swift
//  Top100
//
//  Created by ninja on 2/19/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import AVFoundation

class XmlParserManager: NSObject,NSXMLParserDelegate,UIAlertViewDelegate {
    
    var parser = NSXMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var height = NSString()
    var apiKey = NSString()
    
    // initilise parser
    func initWithURL(url :NSURL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(url :NSURL) {
        feeds = []
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes attributeDict: NSDictionary!) {
        
        element = elementName
        
        if (element as NSString).isEqualToString("entry") {
            elements = NSMutableDictionary.alloc()
            elements = [:]
            ftitle = NSMutableString.alloc()
            ftitle = ""
            link = NSMutableString.alloc()
            link = ""
        }
        else if (element as NSString).isEqualToString("im:image"){
           height = attributeDict.objectForKey("height") as NSString
        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if (elementName as NSString).isEqualToString("entry") {
            if ftitle != "" {
               
                elements.setObject(ftitle, forKey: "title")
        
                //get video ID on youtube
                var originalString = ftitle
                var escapedString = originalString.stringByAddingPercentEncodingWithAllowedCharacters(
                   .URLQueryAllowedCharacterSet())
                var url = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=viewCount&q=\(escapedString!)&type=video&videoCaption=any&videoCategoryId=10&key=\(apiKey)"
                getVideoInfoFromYoutube(url,title:ftitle)
            }
            
            if link != "" {
         
                elements.setObject(link, forKey: "image")
            }
            feeds.addObject(elements)
        }
        
    }
    

    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        var temp = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if element.isEqualToString("title") {
            ftitle.appendString(temp)
        } else if element.isEqualToString("im:image") {
            if height.isEqualToString("170"){
                link.appendString(temp)
            }
        }
    }
    
    //get videoID on Youtube
    func getVideoInfoFromYoutube(url: NSString,title: NSString){
        let urlPath = url;
        let url: NSURL = NSURL(string: urlPath)!
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
            if let vidID = json["items"][0]["id"]["videoId"].stringValue as NSString? {
                println("https://www.youtube.com/watch?v=\(vidID)")
                println(title)
            }
        })
    task.resume()
    }
    
}