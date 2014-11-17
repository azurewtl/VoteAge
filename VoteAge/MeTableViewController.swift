//
//  MeTableViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/15.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
    var loginView = UIView()
    var userLog = UITextField()
    var pwdLog = UITextField()
    var logBtn = UIButton()
    var logDefault = NSUserDefaults.standardUserDefaults()
    override func viewDidLayoutSubviews() {
        
        super.viewDidLoad()
        var username = logDefault.valueForKey("name") as? NSString
        var userpwd = logDefault.valueForKey("pwd") as? NSString
        if(username == "cai"){
            if(userpwd == "pwd"){
                loginView.hidden = true
            }
        }
        loginView.frame = self.view.frame
        loginView.backgroundColor = UIColor.yellowColor()
        userLog.frame = CGRectMake(40, 104, 120, 30);
        userLog.borderStyle = UITextBorderStyle.RoundedRect
        pwdLog.frame = CGRectMake(40, 154, 120, 30);
        pwdLog.borderStyle = UITextBorderStyle.RoundedRect
        pwdLog.secureTextEntry = true
        logBtn.frame = CGRectMake(100, 300, 60, 40);
        logBtn.setTitle("登陆", forState: UIControlState.Normal)
        logBtn.addTarget(self, action:"logBtn1", forControlEvents: UIControlEvents.TouchUpInside)
        logBtn.backgroundColor = UIColor.cyanColor()
        logBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        loginView.addSubview(userLog)
        loginView.addSubview(pwdLog)
        loginView.addSubview(logBtn)
        self.view.addSubview(loginView)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func logBtn1() {
       logDefault.setValue(userLog.text, forKey: "name")
       logDefault.setValue(pwdLog.text, forKey: "pwd")
        if(userLog.text == "cai") {
            if(pwdLog.text == "pwd"){
                loginView.hidden = true
            }
        
        }else{
            print("用户名或者密码错误")
        }
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.

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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell  = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?
        if(indexPath.section == 4 ) {
            if(cell?.textLabel.text == "退出登录") {
            logDefault.removeObjectForKey("name")
            logDefault.removeObjectForKey("pwd")
            let alert = UIAlertView(title: "提示", message: "注销成功", delegate: nil, cancelButtonTitle: "确定")
            cell?.textLabel.text = "登录"
            alert.show()
            self.view.addSubview(alert)
            }else {
                userLog.text = ""
                pwdLog.text = ""
                cell?.textLabel.text = "退出登录"
                loginView.hidden = false
            }
        }
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
