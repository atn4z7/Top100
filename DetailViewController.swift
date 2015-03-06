//
//  DetailViewController.swift
//  Top100
//
//  Created by Nguyen, An Thanh (UMKC-Student) on 3/5/15.
//  Copyright (c) 2015 An Nguyen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.playerView.loadWithVideoId("M7lc1UVf-VE")
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
