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
    var alert:UIAlertView!
    override func viewDidLoad() {
        super.viewDidLoad()
        alert = UIAlertView(title: "提示", message: "网络不稳定", delegate: nil, cancelButtonTitle: "确定")
        self.tabBar.removeFromSuperview()
        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "noti:", name: "logout", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "webBroken:", name: "webout", object: nil)
        // Do any additional setup after loading the view.
    }
    func webBroken(noti:NSNotification) {
        if (noti.userInfo! as NSDictionary).objectForKey("webout") as NSString == "1" {
          alert.show()
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
