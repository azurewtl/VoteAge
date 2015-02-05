//
//  MeTableViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/15.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController, sendbackInforDelegate {
    var addVoteArray = NSMutableArray()
    var tokenDefult = NSUserDefaults.standardUserDefaults()
    @IBOutlet var meHeaderImage: UIImageView!
    
    @IBOutlet var meNicLabel: UILabel!
    
    @IBOutlet var meUserIdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dic = ["userId":tokenDefult.objectForKey("userId") as NSString, "accessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVotePromotionList", resultBlock: { (result) -> Void in
            if result.valueForKey("message") as NSString == "网络出故障啦!" {
               print(result.valueForKey("message"))
            }else if result.valueForKey("list") != nil {
              self.addVoteArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
            }
        })
        var str = tokenDefult.objectForKey("placeholderImage") as NSString
        var data = NSData(base64EncodedString: str, options: nil)
        var placeimg = UIImage(data: data!)
        var url = NSURL(string: tokenDefult.objectForKey("image") as NSString)
        meHeaderImage.sd_setImageWithURL(url, placeholderImage: placeimg)
        meNicLabel.text = tokenDefult.objectForKey("name") as NSString
        meUserIdLabel.text = tokenDefult.objectForKey("userId") as NSString

    }
     func sendbackInfo(str: NSString, img: UIImage) {
        meHeaderImage.image = img
        var strimg = UIImageJPEGRepresentation(img, 1).base64EncodedStringWithOptions(nil)
        tokenDefult.setObject(strimg, forKey: "placeholderImage")
        tokenDefult.setObject(strimg, forKey: "image")
        meNicLabel.text = str
        tokenDefult.setObject(str, forKey: "name")
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
            self.tabBarController?.selectedIndex = 0
            tokenDefult.setValue("", forKey: "userId")
            tokenDefult.setValue("", forKey: "accessToken")
            tokenDefult.setValue("", forKey: "name")
            tokenDefult.setValue("", forKey: "image")
            tokenDefult.setValue(0, forKey: "gender")
            tokenDefult.setValue("", forKey: "description")
            NSNotificationCenter.defaultCenter().postNotificationName("logout", object: nil, userInfo: ["logout":"0"] as NSDictionary)
//            var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
//            self.presentViewController(logVc, animated: true) { () -> Void in
//            }
        }
        
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newvote" {
            if addVoteArray.count > 1 {
            (segue.destinationViewController as NewVoteTableViewController).titleTagArray = addVoteArray
            }
        }
        if segue.identifier == "selfInfo" {
            (segue.destinationViewController as MeDetailTableViewController).delegate = self
        }
        if segue.identifier == "sendVote" {
            (segue.destinationViewController as VoteListTableViewController).pushrelationship = 0
            (segue.destinationViewController as VoteListTableViewController).pushuserId = NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString
        }
        if segue.identifier == "hasVote" {
            (segue.destinationViewController as VoteListTableViewController).pushrelationship = 2
        }
        
    }


}
