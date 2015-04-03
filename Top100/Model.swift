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
    
    
}
let _ModelSharedInstance: Model = { Model() }()
