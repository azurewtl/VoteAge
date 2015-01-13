//
//  MeTableViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/15.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
    var addVoteArray = NSMutableArray()
    var tokenDefult = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dic = ["userId":"15590285735", "accessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVotePromotionList", resultBlock: { (result) -> Void in
            self.addVoteArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
        })
    }
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 2
        case 3: return 2
        case 4: return 1
        default: return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.section == 4 ) {
            var dic = ["method":"delete", "voteId":"38","accessToken":tokenDefult.valueForKey("accessToken") as NSString, "deviceId":tokenDefult.valueForKey("userId") as NSString] as NSDictionary
            print(tokenDefult.valueForKey("accessToken"))
          AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/vote/", resultBlock: { (result) -> Void in
            print(result)
            print(result.valueForKey("message"))
          })
            self.tabBarController?.selectedIndex = 0
            tokenDefult.setValue("", forKey: "userId")
            tokenDefult.setValue("", forKey: "accessToken")
            NSNotificationCenter.defaultCenter().postNotificationName("logout", object: nil, userInfo: ["logout":"0"] as NSDictionary)
//            var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
//            self.presentViewController(logVc, animated: true) { () -> Void in
//            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
               var dic = ["userId":((NSUserDefaults.standardUserDefaults()).valueForKey("userId")) as NSString,"startIndex":"0","endIndex":"10","searchString":"*","relationship":1,"accessToken":((NSUserDefaults.standardUserDefaults()).valueForKey("accessToken")) as NSString] as NSDictionary
                AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/getContactList/", resultBlock: { (result) -> Void in
                    print(result)
                    print(result.valueForKey("message"))
                })
                
            }
        }
        
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newvote" {
            (segue.destinationViewController as NewVoteTableViewController).titleTagArray = addVoteArray
        }
        
    }


}
