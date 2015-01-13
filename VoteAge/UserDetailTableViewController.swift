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
    
        var contactDic = ["userId":NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString, "contactId":"13713098766", "accessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(contactDic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/getRelationship") { (result) -> Void in
            print(result)
            print(result.objectForKey("message"))
        }
        
        
        
        if voteFeed.count != 0 {
        subscribeButton.setTitle(buttonTitle, forState: UIControlState.Normal)
        self.tabBarController?.tabBar.hidden = true
//        authorName.text = voteFeed["authorName"] as NSString
//        var url = NSURL(string: voteFeed["userImage"] as NSString)
//        authorImage.sd_setImageWithURL(url)
//        authorID.text = voteFeed["authorId"] as NSString
//        authorgender.text = voteFeed["gender"] as NSString
//        simpleintroduce.text = voteFeed["describe"] as NSString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Subcribe Button
    
    @IBAction func subscribeButton(sender: UIButton) {
        println("subscribe clicked")
        if sender.currentTitle == "关注" {
        sender.setTitle("取消关注", forState: UIControlState.Normal)
        }else {
            sender.setTitle("关注", forState: UIControlState.Normal)
        }
        var dic = ["userId":"15590285735","contactId":"13789567112", "relationship":2,"accessToken":((NSUserDefaults.standardUserDefaults()).objectForKey("accessToken")) as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/subscribeContact") { (result) -> Void in
            print(result)
            print(result.valueForKey("message"))
        }
        
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
