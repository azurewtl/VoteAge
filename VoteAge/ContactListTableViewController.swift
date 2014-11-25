//
//  MyConcernViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/17.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData

class ContactListTableViewController: UITableViewController {
    var managedObjectContext = NSManagedObjectContext()
    var realSectionArray = NSMutableArray()
    var initialArray = NSMutableArray()
    var totalArray = NSMutableArray()
    var friendArray = NSMutableArray()
    var initialSet = NSMutableSet()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        print(NSTemporaryDirectory())
        let db = DataBaseHandle.shareInstance()
        db.openDB()
        db.createTable("create table Contact(userInital tex, userName tex, userID tex primary key, userImage tex, gender tex, city tex, descibed tex)")
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = app.managedObjectContext!
        // For Test
        var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
        var data1 = NSData(contentsOfFile: path1!)
        
        var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
        //
        friendArray = votedic["friendlist"] as NSMutableArray
        self.presentingViewController
        var sortDiscriptor = NSSortDescriptor(key: "description", ascending: true)
        updateDataBase()
        for letter in initialSet.sortedArrayUsingDescriptors([sortDiscriptor]) {
            initialArray.addObject(letter)
        }
        
        
        for var i = 0; i < initialArray.count; i++  {
            var dic = NSMutableDictionary()
            var str = (initialArray[i] as NSString)
            dic.setObject(db.selectAll("select * from Contact where userInital = '\(str)'"), forKey: "letter")
            totalArray.addObject(dic)
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
        return totalArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //        print(self.realSectionArray.objectAtIndex(section).count)
        var arycoutn = totalArray.objectAtIndex(section)["letter"] as NSArray
        return (arycoutn.count)
        
        //        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        var arname = self.totalArray.objectAtIndex(indexPath.section)["letter"] as NSArray;
        var stringname = arname.objectAtIndex(indexPath.row)["userName"] as NSString
        
        cell.textLabel.text = stringname
        var arimage = self.totalArray.objectAtIndex(indexPath.section)["letter"] as NSArray
        var strimage = arimage.objectAtIndex(indexPath.row)["userImage"] as NSString
        print(strimage)
        var url = NSURL(string: strimage)
        cell.imageView.sd_setImageWithURL(url)
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var ary = self.totalArray.objectAtIndex(section)["letter"] as NSArray
        
        var strback = ary.objectAtIndex(0)["initLetter"] as NSString
        
        return strback
    }
    //
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        return initialArray
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func updateDataBase() {
        let db = DataBaseHandle.shareInstance()
        for index in 0...friendArray.count - 1 {
            var strrUsername = friendArray.objectAtIndex(index)["userName"] as NSString
            var strrUserID = friendArray.objectAtIndex(index)["userID"] as NSString
            var strrUserImage = friendArray.objectAtIndex(index)["userImage"] as NSString
            var strrgender = friendArray.objectAtIndex(index)["gender"] as NSString
            var strrcity = friendArray.objectAtIndex(index)["city"] as NSString
            var strrdescribe = friendArray.objectAtIndex(index)["discription"] as NSString
            var firstLetter = NSString()
            var ff = Int(pinyinFirstLetter(strrUsername.characterAtIndex(0)))
            if(strrUsername.characterAtIndex(0) > 64 && strrUsername.characterAtIndex(0) < 123){
                var ss = Character(UnicodeScalar(strrUsername.characterAtIndex(0).hashValue))
                firstLetter = String(ss)
                
            }else if(ff > 96 && ff < 123){
                
                var char = Int(pinyinFirstLetter(strrUsername.characterAtIndex(0)))
                let c =  Character(UnicodeScalar(char))
                firstLetter = String(c)
            }else{
                firstLetter = "#"
            }
            initialSet.addObject(firstLetter)
            var strinsert = "insert into Contact values('\(strrUsername)', '\(firstLetter)', '\(strrUserID)','\(strrUserImage)', '\(strrgender)', '\(strrcity)', '\(strrdescribe)')"
            db.insertTab(strinsert)
            var strupdate = "update Contact set userName = '\(strrUsername)', userInital = '\(firstLetter)', userImage = '\(strrUserImage)', gender = '\(strrgender)', city = '\(strrcity)', descibed = '\(strrdescribe)' where userID = '\(strrUserID)'"
            db.updateT(strupdate)
        }
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
