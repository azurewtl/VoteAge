//
//  MyConcernViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/17.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class MyConcernViewController: UITableViewController {
    var friendArray = NSMutableArray()
    var albumArray = NSMutableArray()
    var formatArray = NSMutableArray()
    @IBAction func finishSelect(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
        var data1 = NSData(contentsOfFile: path1!)
//        self.albumArray = ["a", "b", "c", "d", "e", "f", "g","h", "i", "j", "k", "l", "m", "n","o", "p", "q", "r", "s", "t", "u","v", "w", "x","y", "z"]
        
        var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
        self.friendArray = votedic.objectForKey("friendlist") as NSMutableArray
        for(var i = 0; i < self.friendArray.count; i++) {
            var strr = self.friendArray.objectAtIndex(i).objectForKey("userName") as NSString
            if(strr.characterAtIndex(0) > 64 && strr.characterAtIndex(0) < 123){
                self.albumArray.addObject(strr)
                var ss = Character(UnicodeScalar(strr.characterAtIndex(0).hashValue))
                self.formatArray.addObject(String(ss))
            }else{
                var string = self.friendArray.objectAtIndex(i).objectForKey("userName") as NSString
                var char = Int(pinyinFirstLetter(string.characterAtIndex(0)))
                let c =  Character(UnicodeScalar(char))
                self.albumArray.addObject(string)
                self.formatArray.addObject(String(c))
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return albumArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.formatArray.objectAtIndex(section).length
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        var string = self.friendArray.objectAtIndex(indexPath.section)["userName"] as NSString
      
        var char = Int(pinyinFirstLetter(string.characterAtIndex(0)))
        let c =  Character(UnicodeScalar(char))
        cell.textLabel.text =  string
        var str = self.friendArray.objectAtIndex(indexPath.section)["userImage"] as NSString
        var url = NSURL(string: str)
        cell.imageView.sd_setImageWithURL(url)
      
       
        return cell
    }
   
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatArray.objectAtIndex(section).description
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return formatArray as NSMutableArray
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
