//
//  LogInViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginClicked(sender: AnyObject) {
        performSegueWithIdentifier("login", sender: self)
    }
    
    
    @IBAction func guestClicked(sender: AnyObject) {
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
