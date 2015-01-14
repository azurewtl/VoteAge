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
    var contactId = NSString()
    var relationship = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        var contactDic = ["userId":NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString, "contactId":contactId, "accessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(contactDic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/getUserInfo") { (result) -> Void in
            print(result)
            print(result.objectForKey("message"))
            var dic = result.valueForKey("list") as NSDictionary
            self.authorName.text = dic["name"] as NSString
            var url = NSURL(string: dic["image"] as NSString)
            self.authorImage.sd_setImageWithURL(url)
            self.authorID.text = dic["userId"] as NSString
            if dic["gender"] as Int == 0 {
                self.authorgender.text = "男"
            }else{
                self.authorgender.text = "女"
            }
            self.simpleintroduce.text = dic["description"] as NSString
            if dic["relationship"] as Int == 0 || dic["relationship"] as Int == 2 {
                self.relationship = 1
                self.subscribeButton.setTitle("关注", forState: UIControlState.Normal)
            }else {
                self.relationship = 2
                 self.subscribeButton.setTitle("取消关注", forState: UIControlState.Normal)
            }
            if self.authorID.text == NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString {
                self.subscribeButton.hidden = true
            }
            
            
        }
        
        self.tabBarController?.tabBar.hidden = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Subcribe Button
    
    @IBAction func subscribeButton(sender: UIButton) {
        print(relationship)
        if sender.currentTitle == "关注" {
        sender.setTitle("取消关注", forState: UIControlState.Normal)
        }else {
            sender.setTitle("关注", forState: UIControlState.Normal)
        }
        var dic = ["userId":NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString,"contactId":authorID.text!, "relationship":relationship,"accessToken":((NSUserDefaults.standardUserDefaults()).objectForKey("accessToken")) as NSString] as NSDictionary
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
