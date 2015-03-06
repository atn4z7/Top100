//
//  DetailViewController.swift
//  Top100
//
//  Created by Nguyen, An Thanh (UMKC-Student) on 3/5/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var Title = NSString()
    var ID = NSString()
    var SearchURL = NSString()
    var videoPlayerViewController: XCDYouTubeVideoPlayerViewController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //encode title, get video ID then play it
        var searchURL = YoutubeHelper.encodeTitle(Title)
        YoutubeHelper.getVideoIDFromYoutube(searchURL){
            (VideoID) in
            if let responseID = VideoID as NSString? {
                dispatch_async(dispatch_get_main_queue(), {
                    //update UI in main thread
                    self.ID = responseID;
                    self.videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: self.ID)
                    self.presentMoviePlayerViewControllerAnimated(self.videoPlayerViewController)
                    });
                
            }
        }

        //self.videoPlayerViewController.presentInView(self.view)
        //self.videoPlayerViewController.moviePlayer.play()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
