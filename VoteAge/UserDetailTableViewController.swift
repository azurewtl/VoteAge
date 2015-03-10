//
//  authorDetailViewControllerTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class UserDetailTableViewController: UITableViewController {
    

    @IBOutlet var haveContactImageView: UIImageView!
    @IBOutlet weak var authorImage: UIImageView!
   
    @IBOutlet var simpleintroduce: UILabel!
 
    @IBOutlet var authorgender: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorID: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    var contactId = Int()
    var relationship = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.haveContactImageView.hidden = true
        var contactDic = ["userId":NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString, "contactId":contactId, "accessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
        var urlStr = NSString(format: "http://voteage.com:8000/api/users/%d/", contactId)
        AFnetworkingJS.netWorkWithURL(urlStr, resultBlock: { (result) -> Void in
            if (result as NSDictionary).objectForKey("message") == nil {
                if result["nickname"] as NSString == ""{
                    self.authorName.text = "游客"
                }else {
                self.authorName.text = result["nickname"] as NSString
                }
                if result["image"]! as? NSString != nil {
                var url = NSURL(string:  NSString(format: "%@", result["image"] as NSString))
                self.authorImage.sd_setImageWithURL(url)
                }else {
                 self.authorImage.image = UIImage(named: "dummyImage")
                }
                self.authorID.text = String((result["id"] as Int))
                if result["gender"] as Int == 1 {
                    self.authorgender.text = "男"
                }else{
                    self.authorgender.text = "女"
                }
//                self.simpleintroduce.text = result["description"] as NSString
                if NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString == "" {
                    
                }else{
                if result["relationship"] as Int == 0 || result["relationship"] as Int == 2 {
                    self.relationship = 1
                    self.subscribeButton.setTitle("关注", forState: UIControlState.Normal)
                    self.haveContactImageView.hidden = true
                }else {
                    self.relationship = 2
                    self.subscribeButton.setTitle("取消关注", forState: UIControlState.Normal)
                    self.haveContactImageView.hidden = false
                }
                if self.authorID.text == NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString {
                    self.subscribeButton.hidden = true
                    self.haveContactImageView.hidden = true
                    self.title = "自己"
                }
                }
                
            }else {
                print("error")
            }
         
        })

        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Subcribe Button
    
    @IBAction func subscribeButton(sender: ActivityButton) {
         sender.juhua.startAnimating()
        var urlStr = NSString()
        if sender.currentTitle == "关注" {
            urlStr = NSString(format: "http://voteage.com:8000/api/users/%d/subscribe/", contactId)
            AFnetworkingJS.uploadJson(nil, url: urlStr) { (result) -> Void in
                print(result)
                if (result as NSDictionary).objectForKey("message") == nil {
                    sender.juhua.stopAnimating()
                    sender.setTitle("取消关注", forState: UIControlState.Normal)
                    self.haveContactImageView.hidden = false
                }else{
                    sender.juhua.stopAnimating()
                    print("故障")
                }
            }
       
        }else {
            urlStr = NSString(format: "http://voteage.com:8000/api/users/%d/unsubscribe/", contactId)
            AFnetworkingJS.uploadJson(nil, url: urlStr) { (result) -> Void in
                print(result)
                if (result as NSDictionary).objectForKey("message") == nil {
                    sender.juhua.stopAnimating()
                    sender.setTitle("关注", forState: UIControlState.Normal)
                    self.haveContactImageView.hidden = true
                }else{
                    sender.juhua.stopAnimating()
                    print("故障")
                }
            }
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "authorImage" {
            (segue.destinationViewController as ImageViewController).photoView.image = authorImage.image
            (segue.destinationViewController as ImageViewController).imgCount = -1
        }
        if segue.identifier == "userVote" {
            (segue.destinationViewController as VoteListViewController).pushrelationship = 0
            (segue.destinationViewController as VoteListViewController).pushuserId = authorID.text!
        }
    }
}
