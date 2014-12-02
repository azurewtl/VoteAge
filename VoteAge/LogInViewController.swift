//
//  LogInViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController{
    
    var logDefault = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var userLogtext: UITextField!
    @IBOutlet weak var passWordText: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
               // Do any additional setup after loading the view.
        var str = "http://127.0.0.1:8000/API/votefeed/"
        AFnetworkingJS.netWorkWithURL(str, resultBlock: { (var result:AnyObject?) -> Void in
//            print(result)
        })
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        userLogtext.resignFirstResponder()
        passWordText.resignFirstResponder()
        var dic1 = ["title":"caocao", "author":"caosbsx", "option":[]] as NSDictionary
        //add:
//        AFnetworkingJS.uploadJson(dic, url: "http://127.0.0.1:8000/API/votefeed/") { (result:Int32!) -> Void in
//            print(result)
//        }
    
        //delete:
//        AFnetworkingJS.removeJson("http://127.0.0.1:8000/API/votefeed/7/", resultBlock: { (result:Int32!) -> Void in
//            print(result)
//        })
        AFnetworkingJS.updateJson("http:127.0.0.1:8000/API/votefeed/8/", dic: dic1) { (result:Int32!) -> Void in
        print(result)
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        if(logDefault.objectForKey("userID") != nil){
            if(logDefault.objectForKey("userID") as NSString == "a") {
                performSegueWithIdentifier("login", sender: self)
            }
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        if(userLogtext.text == "a"){
        logDefault.setObject(userLogtext.text, forKey: "userID")
        performSegueWithIdentifier("login", sender: self)
        }
        userLogtext.text = nil
        
    }
    
    
    @IBAction func guestClicked(sender: AnyObject) {
        logDefault.setObject("guest", forKey: "userID")
        performSegueWithIdentifier("login", sender: self)
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
