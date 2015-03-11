//
//  MeViewController.swift
//  VoteAge
//
//  Created by caiyang on 15/3/4.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, allowVoteDelegate, sendbackInforDelegate {
    var page = 1
    var next = false
    @IBOutlet var headerView: UIImageView!
    
    @IBOutlet var meImageview: UIImageView!
    @IBOutlet var headerLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    var myvoteArray = NSMutableArray()
    
    @IBAction func logOut(sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = 0
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "userId")
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "name")
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "image")
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "gender")
        NSUserDefaults.standardUserDefaults().setValue("", forKey: "description")
        NSNotificationCenter.defaultCenter().postNotificationName("logout", object: nil, userInfo: ["logout":"0"] as NSDictionary)
    }
    
    
    @IBAction func hotTap(sender: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func meTap(sender: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.tabBarController?.selectedIndex = 1
    
    }
    @IBAction func plusOnclick(sender: UIButton) {
        if NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString == "" {
            var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
            self.presentViewController(logVc, animated: true) { () -> Void in
            }
        }else {
            var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var newvoteVc = storyBoard.instantiateViewControllerWithIdentifier("newVote") as NewVoteTableViewController
            self.presentViewController(newvoteVc, animated: true) { () -> Void in
                
            }
        }

    }
    
    @IBAction func nextButtonOnclick(sender: ActivityButton) {
        sender.juhua.startAnimating()
        sender.enabled = false
        if next == true {
        page++
        var urlStr = NSString(format: "http://voteage.com:8000/api/votes/?page=%d&creatorid=%d", (NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString).integerValue, page)
        AFnetworkingJS.netWorkWithURL(urlStr, resultBlock: { (result) -> Void in
            if (result as NSDictionary).objectForKey("message") == nil {
                if result.valueForKey("next")! as? NSString != nil {
                    self.next = true
                }else {
                    self.next = false
                    
                }
                for item in result.objectForKey("results") as NSArray {
                    self.myvoteArray.addObject(item as NSDictionary)
                }
                sender.juhua.stopAnimating()
                self.tableView.reloadData()
                sender.enabled = true
            }else {
                sender.enabled = true
                sender.juhua.stopAnimating()
            }

        })
        }else {
            
            sender.juhua.stopAnimating()
            sender.setTitle("已经划到最底了", forState: UIControlState.Normal)
            sender.enabled = false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AFnetworkingJS.netWorkWithURL("http://voteage.com:8000/api/users/myAccount/", resultBlock: { (result) -> Void in
            if (result as NSDictionary).objectForKey("message") == nil {
                if (result as NSDictionary).objectForKey("image")! as? NSString != nil {
                    var url = NSURL(string: NSString(format: "%@", (result as NSDictionary).objectForKey("image") as NSString))
        
                self.headerView.sd_setImageWithURL(url)
                }
            }else {
                self.headerView.image = UIImage(named: "dummyImage")
                print("error")
            }
        })
        
        meImageview.image = UIImage(named: "wo_green")
        headerView.layer.masksToBounds = true
        headerView.layer.cornerRadius = headerView.frame.width / 2
    
         headerLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("name") as NSString
        
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView?.frame = CGRectMake(0, 0, tableView.frame.width, tableView.frame.height / 3)
                var urlStr = NSString(format: "http://voteage.com:8000/api/votes/?creatorid=%d", (NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString).integerValue)
                AFnetworkingJS.netWorkWithURL(urlStr, resultBlock: { (result) -> Void in
   
                    if (result as NSDictionary).objectForKey("message") == nil {
                        if (result as NSDictionary).objectForKey("next")! as? NSString != nil {
                            self.next = true
                        }
                    self.myvoteArray = NSMutableArray(array: (result as NSDictionary).objectForKey("results") as NSArray)
                    self.tableView.reloadData()
                    }
                })
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myvoteArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("meVote") as UITableViewCell
        if  myvoteArray.count > 0 {
        cell.textLabel?.text = (myvoteArray.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("title") as NSString
        if (myvoteArray.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("image")! as? NSString != nil {
        var url = NSURL(string: (myvoteArray.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("image") as NSString)
        cell.imageView?.sd_setImageWithURL(url)
        }
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我发起的投票"
    }
    func allowVote(count: Int, dic: NSDictionary) {
        myvoteArray.replaceObjectAtIndex(count, withObject: dic)
        tableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myVote" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if myvoteArray.count > 0 {
                    let vote = myvoteArray[indexPath.row] as NSDictionary
                    (segue.destinationViewController as VoteDetailViewController).voteDetail = vote
                    (segue.destinationViewController as VoteDetailViewController).lastPageCellCount = indexPath.row
                    (segue.destinationViewController as VoteDetailViewController).delegate = self
                }
                
            }
        }
        if segue.identifier == "Mydetail" {
                (segue.destinationViewController as MeDetailTableViewController).delegate = self
      
            
            }
        if segue.identifier == "imageSegue" {
            (segue.destinationViewController as ImageViewController).photoView.image = headerView.image
            (segue.destinationViewController as ImageViewController).imgCount = -1
        }

        
       
    }
    //MARK:-detail  protocol
    func sendbackInfo(str: NSString, img: UIImage) {
        headerView.image = img
        headerLabel.text = str
        NSUserDefaults.standardUserDefaults().setObject(str, forKey: "name")
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
