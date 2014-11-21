//
//  MeDetailTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/20.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class MeDetailTableViewController: UITableViewController, UIActionSheetDelegate {
    
    @IBAction func saveButton(sender: UIButton) {
//        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
//        let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
//        let cell3 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2))
//        let cell4 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 2))
//        let imageView = cell?.contentView.viewWithTag(101) as UIImageView
//        let nameText = cell?.contentView.viewWithTag(102) as UITextField
//        let locationText = cell2?.contentView.viewWithTag(101) as UITextField
//        let sexText = cell3?.contentView.viewWithTag(101) as UITextField
//        let detailTextview = cell4?.contentView.viewWithTag(101) as UITextView
// 
//            detailTextview.editable = false
//            nameText.enabled = false
//            locationText.enabled = false
//            sexText.enabled = false
      
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        let imageView = cell?.contentView.viewWithTag(101) as UIImageView
        var imageGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(imageGesture)
    }
    func tapGesture() {
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)
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
        return 1
        case 1:
        return 1
        case 2:
        return 3
        default:
        return 0
        }
    }


//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("meCell", forIndexPath: indexPath) as UITableViewCell
//
//        // Configure the cell...
//
//        return cell
//    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
    let cell3 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 2))
    let cell4 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 2))
    let nameText = cell?.contentView.viewWithTag(102) as UITextField
    let locationText = cell2?.contentView.viewWithTag(101) as UITextField
    let sexText = cell3?.contentView.viewWithTag(101) as UITextField
    let detailTextview = cell4?.contentView.viewWithTag(101) as UITextView
        nameText.resignFirstResponder()
        locationText.resignFirstResponder()
        sexText.resignFirstResponder()
        detailTextview.resignFirstResponder()
        
    }
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
