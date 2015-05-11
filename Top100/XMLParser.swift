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

class XmlParserManager: NSObject,NSXMLParserDelegate {
    
    private var parser = NSXMLParser()
    private var feeds = NSMutableArray()
    private var elements = NSMutableDictionary()
    private var element = NSString()
    private var ftitle = NSMutableString()
    private var link = NSMutableString()
    private var height = NSString()
  
    public func getFeeds() -> NSMutableArray {
        return feeds
    }
    
    // initilise parser
    internal func initWithURL(url :NSURL) -> AnyObject {
        startParse(url)
        return self
    }
    
    internal func startParse(url :NSURL) {
        feeds = []
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    private func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    internal func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes attributeDict: NSDictionary!) {
        
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
    
    internal func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if (elementName as NSString).isEqualToString("entry") {
            if ftitle != "" {
               
                elements.setObject(ftitle, forKey: "title")
            }
            
            if link != "" {
         
                elements.setObject(link, forKey: "image")
            }
            feeds.addObject(elements)
        }
        
    }
    

    internal func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        var temp = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if element.isEqualToString("title") {
            ftitle.appendString(temp)
        } else if element.isEqualToString("im:image") {
            if height.isEqualToString("170"){
                link.appendString(temp)
            }
        }
    }
    
 }