//
//  authorDetailViewControllerTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UITableViewController {
    

    @IBOutlet weak var authorImage: UIImageView!
   
   
    @IBOutlet var simpleintroduce: UILabel!
 
    @IBOutlet var authorgender: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorID: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    var voteFeed: NSDictionary = NSDictionary()
    var buttonTitle = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()

        if voteFeed.count != 0 {
        subscribeButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        self.tabBarController?.tabBar.hidden = true
        authorName.text = voteFeed["userName"] as NSString
        var url = NSURL(string: voteFeed["userImage"] as NSString)
        authorImage.sd_setImageWithURL(url)
        authorID.text = voteFeed["userID"] as NSString
        authorgender.text = voteFeed["gender"] as NSString
        simpleintroduce.text = voteFeed["describe"] as NSString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Subcribe Button
    
    @IBAction func subscribeButton(sender: UIButton) {
        println("subscribe clicked")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return 1
            case 2: return 2
        default: return 0
        }
    }
    
}
