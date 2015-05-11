//
//  DetailViewController.swift
//  Top100
//
//  Created by Nguyen, An Thanh (UMKC-Student) on 3/5/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet private var sharebutton: UIButton!
    
    @IBOutlet private var favoritebutton: UIButton!
    
    @IBOutlet private var playerView: UIView!
    
    private var parentVC = NSString()
    private var index : Int!
    private var nextIndex : Int!
    private var Title = NSString()
    private var PicLink = NSString()
    private var ID = NSString()
    private var SearchURL = NSString()
    private var videoURL = NSString()
    private var videoPlayerViewController: XCDYouTubeVideoPlayerViewController!
    private let model = Model.sharedInstance()
    
    internal func setTitle(title : String){
        Title = title
    }
    
    internal func setPicLink(link : String){
        PicLink = link
    }
    
    internal func setIndex(index : Int){
        self.index = index
    }
    internal func setParentVC(parent : String){
        parentVC = parent
    }
    
    @IBAction private func share(sender: UIButton) {
        share()
    }
    
    @IBAction private func favorite(sender: UIButton) {
        model.addSong(PicLink, Title: Title)
        favoritebutton.enabled = false
    }
    
    private func iniUI(){
        //adding border to buttons
        sharebutton.layer.cornerRadius = 2
        sharebutton.layer.borderWidth = 1
        sharebutton.layer.borderColor = sharebutton.tintColor!.CGColor
        favoritebutton.layer.cornerRadius = 2
        favoritebutton.layer.borderWidth = 1
        favoritebutton.layer.borderColor = favoritebutton.tintColor!.CGColor
        
        //set title
        assert(Title.length > 0 , "Title should not be empty")
        self.navigationItem.title = Title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iniUI()
        
        if parentVC == "TableViewController" {
            // parentVC is TableViewController
            println("parentVC is TableViewController")
        } else if parentVC == "FavoritesViewController" {
            // parentVC is FavoritesViewController
            println("parentVC is FavoritesViewController")
            favoritebutton.hidden = true
        }
        
        
        //play current selected video
        playCurrentVideo(Title)
        //increment nextIndex
        nextIndex = index + 1
        assert(nextIndex < 100, "index must stay in the 0-100 range since this is a top 100 song list")
        
        /*
        // create share buttons
        var shareBtn = UIBarButtonItem(image: UIImage(named: "ic_share.png"), style: .Plain, target: self, action: "share")
        var buttons: [UIBarButtonItem] = [shareBtn];
        //add share button to navigation bar
        self.navigationItem.rightBarButtonItems = buttons;
        */
    }
    
    //function to share song with friends
    private func share() {
        
        println("Sharing Activated!")
        var sharingItems = [AnyObject]()
        
        let text = "Check out this song: \(Title)"
        sharingItems.append(text)
        
        /*
        if let image = sharingImage {
        sharingItems.append(image)
        }
        */
        let url = "https://www.youtube.com/watch?v=\(ID)"
        sharingItems.append(url)
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func iniPlayer(ID : String){
        //init video player
        self.videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: ID)
        
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
        
        //present the player and play video
        self.videoPlayerViewController.presentInView(self.playerView)
        self.videoPlayerViewController.moviePlayer.play()
        
        //self.presentMoviePlayerViewControllerAnimated(self.videoPlayerViewController)
    }
    
    private func playCurrentVideo(title:NSString){
        //encode title, get video ID then play it
        var searchURL = YoutubeHelper.encodeTitle(title)
        //search video ID in a separate thread
        YoutubeHelper.getVideoIDFromYoutube(searchURL){
            (VideoID) in
            if let responseID = VideoID as NSString? {
                self.ID = responseID
                //back to main thread to update UI
                dispatch_async(dispatch_get_main_queue(), {
                    self.iniPlayer(responseID)
                });
            }
        }
    }
    
    private func playAnyVideo(title:NSString){
        //encode title, get video ID (in a separate thread) then play it
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
    
    private func moviePlayBackDidFinish(notification:NSNotification) {
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
