//
//  RegisterTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController, UITextFieldDelegate {

    var rowCount = 3
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!

    @IBOutlet weak var senderVertiButton: UIButton!
    @IBAction func sendVertificationButton(sender: UIButton) {
        
        if phoneTextField.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 11 {
            Vertify.getphone(phoneTextField.text, block: { (var result:Int32) -> Void in
                if result == 1 {
                    sender.setTitle("发送成功", forState: UIControlState.Normal)
                    sender.enabled = false
                    self.rowCount = 5
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
                sender.enabled = false
                self.rowCount = 9
                self.tableView.reloadData()
            }else {
                sender.setTitle("验证失败", forState: UIControlState.Normal)
            }
        })
        
        
    }
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerifyTextField: UITextField!
  
    
    @IBAction func submitButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
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
       phoneTextField.delegate = self
       verificationTextField.delegate = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "back")
    }
    func back() {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return rowCount
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
