//
//  MyConcernViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/17.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData

class ContactListTableViewController: UITableViewController, UISearchBarDelegate{
    
    
    @IBOutlet var searchBar: UISearchBar!
    var userdic = NSMutableDictionary()
    var userarray = NSMutableArray()
    
    var selectedCell = NSDictionary() // store list of selected cell when composing new vote
    var initialArray = NSArray() // store sorted initial of all contacts
    var contactArray = NSMutableArray() // store sorted contact info corresponding to initialArray
    var friendArray = NSMutableArray()//接口list
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        searchBar.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.sectionIndexBackgroundColor = UIColor(white: 1, alpha: 0.0) // set index bar to transparent
      
        tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        // Initialize data base
        let db = DataBaseHandle.shareInstance()
        db.openDB()
        db.createTable("create table Contact(userInital tex, userName tex, userID tex primary key, userImage tex, gender tex, city tex, descibed tex)")
//         For Test
//        var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
//        var data1 = NSData(contentsOfFile: path1!)
//        var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
        
        var dic = ["userId":((NSUserDefaults.standardUserDefaults()).valueForKey("userId")) as NSString,"startIndex":"0","endIndex":"100","searchString":"*","relationship":1,"accessToken":((NSUserDefaults.standardUserDefaults()).valueForKey("accessToken")) as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/getContactList/", resultBlock: { (result) -> Void in
            print(result)
            print(result.valueForKey("message"))
            if result.valueForKey("message") as NSString == "网络出故障啦!" {
                 print("网络出故障啦!")
            }else if result.valueForKey("list") != nil {
                
                self.friendArray =  NSMutableArray(array: result.valueForKey("list") as NSArray)
              
                for index in 0...self.friendArray.count - 1 {
                    self.userdic.setObject(self.friendArray.objectAtIndex(index)["userId"] as NSString, forKey: self.friendArray.objectAtIndex(index)["name"] as NSString)
                }
                self.userarray.addObject(self.userdic)
                self.updateDataBaseAndInitialArray(self.friendArray)
                // Update contactArray accroding to initalArray
                for var i = 0; i < self.initialArray.count; i++  {
                    var contactInfo = NSMutableDictionary()
                    var str = (self.initialArray[i] as NSString)
                    contactInfo.setObject(db.selectAll("select * from Contact where userInital = '\(str)'"), forKey: "letter")
                    self.contactArray.addObject(contactInfo)
                    self.tableView.reloadData()
                }
               
            }
        })
        // test end

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Search Bar delegate
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
     
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var searchVc = storyboard.instantiateViewControllerWithIdentifier("search") as SearchViewController
        
        searchVc.searchArray = NSArray(array: userarray)
        self.navigationController?.pushViewController(searchVc, animated: false)
        
        return true
    }
    
    
    // MARK: - update
    func updateDataBaseAndInitialArray(friendArray: NSArray){
        let db = DataBaseHandle.shareInstance()
        var initialSet = NSMutableSet()
        if friendArray.count > 0 {
        for index in 0...friendArray.count - 1 {
            var strrUsername = friendArray.objectAtIndex(index)["name"] as NSString
            var strrUserID = friendArray.objectAtIndex(index)["userId"] as NSString
            var strrUserImage = NSString(format: "http://73562.vhost33.cloudvhost.net/VoteAge/Public/Uploads/%@",friendArray.objectAtIndex(index)["image"] as NSString)
//            var strrgender = friendArray.objectAtIndex(index)["gender"] as NSString
//            var strrcity = friendArray.objectAtIndex(index)["city"] as NSString
            var strrdescribe = friendArray.objectAtIndex(index)["description"] as NSString
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
            
            var strinsert = "insert into Contact values('\(strrUsername)', '\(firstLetter)', '\(strrUserID)','\(strrUserImage)', '\"0\"', '\"0\"', '\(strrdescribe)')"
            db.insertTab(strinsert)
            var strupdate = "update Contact set userName = '\(strrUsername)', userInital = '\(firstLetter)', userImage = '\(strrUserImage)', gender = '0', city = '0', descibed = '\(strrdescribe)' where userID = '\(strrUserID)'"
            db.updateT(strupdate)
        }
        
        let sortDiscriptor = NSSortDescriptor(key: "description", ascending: true)
        initialArray = initialSet.sortedArrayUsingDescriptors([sortDiscriptor])
        }
    }
    
   
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return contactArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var arycoutn = contactArray.objectAtIndex(section)["letter"] as NSArray
        return (arycoutn.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as UITableViewCell
        // Configure the cell...
        var arname = self.contactArray.objectAtIndex(indexPath.section)["letter"] as NSArray;
        var stringname = arname.objectAtIndex(indexPath.row)["userName"] as NSString
        cell.textLabel!.text = stringname
        var arId = self.contactArray.objectAtIndex(indexPath.section)["letter"] as NSArray;
        var stringId = arname.objectAtIndex(indexPath.row)["userID"] as NSString
        cell.detailTextLabel?.text = stringId
        
        var arimage = self.contactArray.objectAtIndex(indexPath.section)["letter"] as NSArray
        var strimage = arimage.objectAtIndex(indexPath.row)["userImage"] as NSString
        
        var url = NSURL(string: strimage)
        cell.imageView!.sd_setImageWithURL(url)
        return cell
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var ary = self.contactArray.objectAtIndex(section)["letter"] as NSArray
        
        var strback = ary.objectAtIndex(0)["initLetter"] as NSString
        
        return strback
    }
    //
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        return initialArray
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //        selectedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)) as UITableViewCell!
//        var array = contactArray.objectAtIndex(indexPath.section)["letter"] as NSArray
//        selectedCell = array.objectAtIndex(indexPath.row) as NSDictionary
        
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
    
    
    // MARK: - Segue
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "contactDetail" {
            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            print(friendArray.objectAtIndex(indexPath.row)["userId"] as NSString)
            (segue.destinationViewController as UserDetailTableViewController).contactId = (cell?.detailTextLabel?.text as NSString!)
        }
    }
    
}
