//
//  RegisterTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    var timeInterval = Int()
    var timer = NSTimer()
    var tokenDefult = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var senderVertiButton: UIButton!
    var cellCount = 0
    var cellCount1 = 0
    @IBOutlet var backButton: UIButton!
    
    @IBAction func backOnclick(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBAction func sendVertificationButton(sender: UIButton) {
        
        if phoneTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 11 {
            Vertify.getphone(phoneTextField.text, block: { (var result:Int32) -> Void in
                if result == 1 {
                    sender.setTitle("发送成功", forState: UIControlState.Normal)
                    self.vertiButton.enabled = true
                    self.timeraction()
                    sender.enabled = false
                    for index in 0...2 {
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1)) as UITableViewCell?
                        cell?.hidden = false
                    }
                    self.cellCount = 3
                    self.tableView.reloadData()
                }else {
                   sender.setTitle("发送失败", forState: UIControlState.Normal)
                }
                
         })
    
        }else {
            sender.setTitle("手机号错误", forState: UIControlState.Normal)
        }
        
    }
    @IBOutlet weak var verificationTextField: UITextField!
    
    @IBOutlet weak var vertiButton: UIButton!
    @IBAction func vertificationButton(sender: UIButton) {
        
        Vertify.getvertifynumber(verificationTextField.text, block: { (var result:Int32) -> Void in
            if result == 1 {
                sender.setTitle("验证成功", forState: UIControlState.Normal)
                self.timer.invalidate()
                self.timeLabel.hidden = true
                sender.enabled = false
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as UITableViewCell?
                cell?.hidden = false
                self.cellCount1 = 1
                self.tableView.reloadData()
            }else {
                sender.setTitle("验证失败", forState: UIControlState.Normal)
            }
        })
        
        
    }
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
  
    
    @IBAction func submitButton(sender: UIButton) {
     print(genderSegmentControl.selectedSegmentIndex)
      let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as UITableViewCell?
        var textfield = cell?.contentView.viewWithTag(102) as UITextField
      var dic = ["mobile":textfield.text, "password":((textfield.text as NSString).integerValue + 1).description , "gender":genderSegmentControl.selectedSegmentIndex + 1, "deviceId":tokenDefult.objectForKey("userId") as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/login") { (result) -> Void in
            print(result)
           
            self.tokenDefult.setValue((result!.valueForKey("accessToken")) as NSString, forKey: "accessToken")
            self.tokenDefult.setValue(textfield.text, forKey: "userId")
            print(result.valueForKey("message"))
            
        }
        dismissViewControllerAnimated(true, completion: { () -> Void in
            var logoutDic = ["logout":"1"] as NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName("logout", object: nil, userInfo: logoutDic)
        })
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        phoneTextField.resignFirstResponder()
        verificationTextField.resignFirstResponder()
        return true
    }
     func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField && senderVertiButton.enabled == true {
           senderVertiButton.setTitle("发送验证码", forState: UIControlState.Normal)
        }else if textField == verificationTextField && vertiButton.enabled == true {
           vertiButton.setTitle("验证", forState: UIControlState.Normal)
        }
        return true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView?.backgroundColor = tableView.backgroundColor
        phoneTextField.delegate = self
        verificationTextField.delegate = self
        phoneTextField.keyboardType = UIKeyboardType.PhonePad
        verificationTextField.keyboardType = UIKeyboardType.PhonePad
        backButton.clipsToBounds = true
        backButton.layer.cornerRadius = 15
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        for index in 0...2 {
//        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1)) as UITableViewCell?
//        cell?.hidden = true
//        }
//       let cell1 =  tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as UITableViewCell?
//        cell1?.hidden = true
    }

    func timeraction() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timegoing", userInfo: nil, repeats: true)
        timer.fire()
        
    }
    func timegoing() {
        timeInterval++
        timeLabel.text = (60 - timeInterval).description + "秒倒计时"
        if timeInterval > 60 {
            timer.invalidate()
            timeInterval = 0
            timeLabel.text = "超时,请重发"
            senderVertiButton.enabled = true
            vertiButton.enabled = false
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
        case 0:
            return 3
        case 1:
            return cellCount
        case 2:
            return cellCount1
        default:
            return 0
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
