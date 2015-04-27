//
//  FavoritesViewControllerTests.swift
//  Top100
//
//  Created by ninja on 4/26/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import XCTest
import Top100

class FavoritesViewControllerTests: XCTestCase {
    var testObject : Model?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        testObject = Model()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDeleteSong() {
        testObject?.deleteSong("21")
        var found = false
        testObject?.getAllSongs(){result in
            for song in result {
                if let songtemp = song as? NSDictionary {
                    if songtemp.objectForKey("SongID") as String == "21"{
                        found = true
                        break
                    }
                }
            }
            XCTAssert(found, "Problem deleting song from database")
        }
    }
}
