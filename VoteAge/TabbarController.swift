//
//  TabbarController.swift
//  VoteAge
//
//  Created by caiyang on 15/1/7.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate{
    var userDefault = NSUserDefaults.standardUserDefaults()
    var addBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var addimageView = UIImageView(frame: CGRectMake(0, 0, 60, 60))
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.frame = CGRectMake(0, 0, 80, 80)
        addBtn.backgroundColor = UIColor.grayColor()
        addBtn.layer.masksToBounds = true
        addBtn.layer.cornerRadius = 40
        addBtn.center = tabBar.center
        self.view.addSubview(addBtn)
        addBtn.addTarget(self, action: "onclick:", forControlEvents: UIControlEvents.TouchUpInside)
        addimageView.center = addBtn.center
        addimageView.layer.masksToBounds = true
        addimageView.layer.cornerRadius = 30
        addimageView.backgroundColor = UIColor.whiteColor()
        addimageView.image = UIImage(named: "plus")
        self.view.addSubview(addimageView)
        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noti:", name: "logout", object: nil)
        // Do any additional setup after loading the view.
    }
    func onclick(click:UIButton) {
        
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
    func noti(noti:NSNotification) {
        if (noti.userInfo! as NSDictionary).objectForKey("logout") as NSString == "1" {
            self.selectedIndex = 1
        }
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        print(item.tag)
        if item.tag == 1 {
           print(userDefault.objectForKey("accessToken") as NSString)
            if userDefault.objectForKey("accessToken") as NSString == "" {
               
                var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
                presentViewController(logVc, animated: true, completion: { () -> Void in
                    
                })
            }
        }
//       
//        if item.tag == 3 {
//            if userDefault.objectForKey("userId") as NSString == "" {
//                
//                var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//                var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
//                presentViewController(logVc, animated: true, completion: { () -> Void in
//                    
//                })
//            }
//           
//            
//        }
    }
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            if userDefault.objectForKey("accessToken") as NSString == ""{
                return false
            }else {
                return true
            }
        }
     
    return true
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
