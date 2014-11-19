//
//  MyConcernViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/17.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData

class MyConcernViewController: UITableViewController {
    var managedObjectContext = NSManagedObjectContext()
    var realSectionArray = NSMutableArray()
    var initialArray = NSMutableArray()
    var totalArray = NSMutableArray()
    var friendArray = NSMutableArray()
    var initialSet = NSMutableSet()
//    完成
    @IBAction func finishSelect(sender: UIButton) {
    
    }
//    更新
    func updateCoreData(index:Int) {
    
        
        }
//    插入
    func saveToCoreData(index:Int) {
        let db = DataBaseHandle.shareInstance()
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
        db.insertTab(firstLetter, uname: strrUsername, uid: strrUserID, uimage: strrUserImage, ugender: strrgender, ucity: strrcity, udescibe: strrdescribe)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = DataBaseHandle.shareInstance()
        db.openDB()
        db.createTable()
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = app.managedObjectContext!
        
        // For Test
        var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
        var data1 = NSData(contentsOfFile: path1!)

        var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
        //
        
        friendArray = votedic["friendlist"] as NSMutableArray
   
        for index in 0...friendArray.count - 1 {
            saveToCoreData(index)
        }

        var sortDiscriptor = NSSortDescriptor(key: "description", ascending: true)
        for letter in initialSet.sortedArrayUsingDescriptors([sortDiscriptor]) {
            initialArray.addObject(letter)
        }
       
        print(initialArray)
        for var i = 0; i < initialArray.count; i++  {
           var dic = NSMutableDictionary()
            dic.setObject(db.selectAll(initialArray[i] as NSString), forKey: "letter")
            totalArray.addObject(dic)
        }
//       print(totalArray)
      
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
//
////        var char = Int(pinyinFirstLetter(string.characterAtIndex(0)))
////        let c =  Character(UnicodeScalar(char))
        cell.textLabel.text = stringname
//        cell.textLabel.text = "121"
        var arimage = self.totalArray.objectAtIndex(indexPath.section)["letter"] as NSArray
        var strimage = arimage.objectAtIndex(indexPath.row)["userImage"] as NSString
        var url = NSURL(string: strimage)
        cell.imageView.sd_setImageWithURL(url)
//
       
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
