//
//  DetailViewController.swift
//  Top100
//
//  Created by Nguyen, An Thanh (UMKC-Student) on 3/5/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var index : Int!
    var nextIndex : Int!
    var Title = NSString()
    var ID = NSString()
    var SearchURL = NSString()
    var videoPlayerViewController: XCDYouTubeVideoPlayerViewController!
    let model = Model.sharedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //play current selected video
        playCurrentVideo(Title)
        //init nextIndex
        nextIndex = index + 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func playCurrentVideo(title:NSString){
        //encode title, get video ID then play it
        var searchURL = YoutubeHelper.encodeTitle(title)
        //search video ID in new threads
            YoutubeHelper.getVideoIDFromYoutube(searchURL){
                (VideoID) in
                if let responseID = VideoID as NSString? {
                    dispatch_async(dispatch_get_main_queue(), {
                        //init video player
                        self.videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: responseID)
                        //remove default behavior
                        NSNotificationCenter.defaultCenter().removeObserver(
                            self.videoPlayerViewController,
                            name: MPMoviePlayerPlaybackDidFinishNotification,
                            object: self.videoPlayerViewController.moviePlayer)
                        //add our own
                        NSNotificationCenter.defaultCenter().addObserver(
                            self,
                            selector: "moviePlayBackDidFinish:",
                            name: MPMoviePlayerPlaybackDidFinishNotification,
                            object: self.videoPlayerViewController.moviePlayer)
                        
                        
                        self.presentMoviePlayerViewControllerAnimated(self.videoPlayerViewController)
                    });
                }
            }
    }
    
    func playAnyVideo(title:NSString){
        //encode title, get video ID then play it
        var searchURL = YoutubeHelper.encodeTitle(title)
        
        YoutubeHelper.getVideoIDFromYoutube(searchURL){
            (VideoID) in
            if let responseID = VideoID as NSString? {
                dispatch_async(dispatch_get_main_queue(), {
                    //play video
                    self.videoPlayerViewController.SETVideoIdentifier(responseID)
                });
            }
        }
    }
    
    func moviePlayBackDidFinish(notification:NSNotification) {
        //get userinfo
        if let userInfo = notification.userInfo {
            if let value = (userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]) as? Int{
                println(value)
                if (value == 2) { //user clicked done button
                    println("done clicked")
                    //dismiss the player
                    self.dismissMoviePlayerViewControllerAnimated()
                }
                else{ //user clicked next/previous => play next video in list
                    println("play next index:\(nextIndex)")
                    //get next video
                    var nextVideo = model.getItem(nextIndex)
                    //play it
                    playAnyVideo(nextVideo.objectForKey("title") as NSString)
                    //increment next index
                    nextIndex = nextIndex + 1
                    
                }
            }
        }
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
