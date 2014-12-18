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
    var logDefault = NSUserDefaults.standardUserDefaults()
    override func viewDidLayoutSubviews() {
        
        super.viewDidLoad()
        var path = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
        var data = NSData(contentsOfFile: path!)
        var dic = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        addVoteArray = dic["adVote"] as NSMutableArray
        
 //        var userpwd = logDefault.valueForKey("pwd") as? NSString

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        let  cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 4)) as UITableViewCell?
        if(logDefault.objectForKey("userID") as NSString == "guest") {
            cell?.textLabel.text = "登录"
        print(logDefault.objectForKey("userID"))
    
        }else{
            cell?.textLabel.text = "退出登录"
        }
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
           logDefault.setObject("", forKey: "userID")
            dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newvote" {
            (segue.destinationViewController as NewVoteTableViewController).titleTagArray = addVoteArray
        }
        
    }


}
