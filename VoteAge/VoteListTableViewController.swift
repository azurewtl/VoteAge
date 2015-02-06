//
//  MasterViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class VoteListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,  UIActionSheetDelegate, CLLocationManagerDelegate, sendInfoDelegate,allowVoteDelegate{
    var locationManager = CLLocationManager()
    @IBAction func optionButton(sender: UIBarButtonItem) {
        var sheet  = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "附近", "热点")
        sheet.showInView(self.view)
    }
    var pushrelationship = -1
    var actionSheetTag = 0//1热点 2附近 0全部
    var longi:Double = 0//经度
    var lati:Double = 0//纬度
    var pushuserId = ""
    
    var startIndex = 0
    var endIndex = 20
    var managedObjectContext: NSManagedObjectContext? = nil
    var voteArray = NSMutableArray()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var dragDownactivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var dragImageView = UIImageView()
    
    @IBOutlet var loadActivityView: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
        actionSheetTag = 1
        self.activityIndicator.startAnimating()
        updateLocation(locationManager)
        self.title = "附近"
        }
        if buttonIndex == 2 {
            actionSheetTag = 2
           self.title = "热点"
            self.activityIndicator.startAnimating()
            if self.tabBarController?.selectedIndex == 0 {
            refresh(1, longit: "", latit: "", startindex:"0", endindex:"20", userid:"", relationship:0)
            }
            if pushrelationship == 0 {
                refresh(1, longit: "", latit: "", startindex:"0", endindex:"20", userid:pushuserId,relationship:0)
            }
            if pushrelationship == 2 {
                refresh(1, longit: "", latit: "", startindex:"0", endindex:"20", userid:NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString,relationship:2)
            }

        }
    }
    func updateLocation(locationManager: CLLocationManager) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.delegate = self
        if UIDevice.currentDevice().systemVersion >= "8.0" {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        print(error)
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc = locations.last as CLLocation
        var coord = loc.coordinate
        lati = coord.latitude
        longi = coord.longitude
        if self.tabBarController?.selectedIndex == 0 {
        refresh(2, longit:coord.latitude.description, latit: coord.longitude.description,startindex:"0", endindex:"20", userid:"", relationship:0)
        }
        if pushrelationship == 0 {
            refresh(2, longit: "", latit: "", startindex:"0", endindex:"20", userid:pushuserId,relationship:0)
        }
        if pushrelationship == 2 {
            refresh(2, longit: "", latit: "", startindex:"0", endindex:"20", userid:NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString,relationship:2)
        }
        manager.stopUpdatingLocation()
    }
       override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
     
        
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragImageView.hidden = false
        dragImageView.image = UIImage(named:"dragUp")
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -140 {
            dragImageView.image = UIImage(named:"dragDown")
        }else{
           dragImageView.image = UIImage(named:"dragUp")
        }
       
    }
    // MARK: -上拉加载
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
     
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height{
            loadActivityView.hidden = false
            loadActivityView.startAnimating()
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
                }, completion: { (finish) -> Void in
                    self.startIndex += 20
                    self.endIndex += 20
                    var uid = NSString()
                    if self.tabBarController?.selectedIndex == 0 {
                        uid = ""
                    }
                    if self.pushrelationship == 0 {
                        uid = self.pushuserId
                    }
                    if self.pushrelationship == 2 {
                        uid = NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString
                    }
                        var dic = ["tag":self.actionSheetTag,"longitude":self.longi.description, "latitude":self.lati.description, "accessToken":"", "userId":uid,"startIndex":self.startIndex.description,"endIndex":self.endIndex.description, "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "relationship":self.pushrelationship] as NSDictionary
                        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
//                            print(result)
                            if result.objectForKey("message") as NSString == "网络出故障啦!" {
                                print("网络故障")
                                self.loadActivityView.stopAnimating()
                                self.loadActivityView.hidden = true
                            }else {
                            
                                for item in result.objectForKey("list") as NSArray {
                                    self.voteArray.addObject(item as NSDictionary)
                                }
                                self.tableView.reloadData()
                                scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
                                self.loadActivityView.hidden = true
                            }
                        }
            })
            
        }else {
            loadActivityView.stopAnimating()
        }
  

    }
    // MARK: -下拉刷新
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
         self.dragImageView.hidden = true
         dragImageView.image = UIImage(named:"dragUp")
            if scrollView.contentOffset.y < -140 {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let group = dispatch_group_create()
             self.dragDownactivity.startAnimating()
            dispatch_group_async(group, queue, {
                scrollView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0)
            })
            dispatch_group_notify(group, queue, {
                var uid = NSString()
                if self.tabBarController?.selectedIndex == 0 {
                    uid = ""
                }
                if self.pushrelationship == 0 {
                    uid = self.pushuserId
                }
                if self.pushrelationship == 2 {
                    uid = NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString
                }
                var dic = ["accessToken":"", "userId":uid,"startIndex":"0","endIndex":"20", "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "relationship":self.pushrelationship] as NSDictionary
                AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
//                    print(result)
                    if result.objectForKey("message") as NSString == "网络出故障啦!" {
                        print("网络故障")
                    }else {
                        print(result.objectForKey("message"))
                        
                        self.voteArray = NSMutableArray(array: result.objectForKey("list") as NSArray)
                        self.tableView.reloadData()
                        self.startIndex = 0
                        self.endIndex = 0
                        self.actionSheetTag = 0
                    }
                    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
                    self.dragDownactivity.stopAnimating()
                    self.title = "全部"
                }
                
            })
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadActivityView.hidden = true
        activityIndicator.frame = CGRectMake(0, 150, 50, 50)
        activityIndicator.center.x = view.center.x
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 5
        self.activityIndicator.startAnimating()
        getLoginStatus()
        tableView.tableHeaderView = UIView(frame: CGRectMake(0.1, 0.1, view.frame.width, 0.1))
        self.view.addSubview(activityIndicator)
        //下拉刷新
        dragDownactivity.frame = CGRectMake(150, -50, 50, 50)
        dragDownactivity.center.x = view.center.x
        self.view.addSubview(dragDownactivity)
        dragImageView.frame = CGRectMake(150, -50, 50, 50)
        dragImageView.center = CGPointMake(view.center.x, dragImageView.center.y)
        dragImageView.image = UIImage(named: "dragUp")
        self.view.addSubview(dragImageView)
        dragImageView.highlighted = true
        if self.tabBarController?.selectedIndex == 0 && pushrelationship == -1 {
        refresh(0, longit: "", latit: "", startindex:"0", endindex:"20", userid:"",relationship:0)
        }
        if pushrelationship == 0 {
            print(pushuserId)
            if pushuserId == NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString {
            self.title = "我发起的"
            }else {
                self.title = pushuserId
            }
            refresh(0, longit: "", latit: "", startindex:"0", endindex:"20", userid:pushuserId,relationship:0)
            
        }
        if pushrelationship == 2 {
            self.title = "我参与的"
            refresh(0, longit: "", latit: "", startindex:"0", endindex:"20", userid:NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString,relationship:2)
        }
        
    }
    // MARK: - 判断token是否匹配
    func getLoginStatus() {
        var dic = ["userId":(NSUserDefaults.standardUserDefaults().objectForKey("userId")) as NSString, "accessToken":(NSUserDefaults.standardUserDefaults().objectForKey("accessToken")) as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/getLoginStatus") { (result) -> Void in
//            print(result)
            if result.objectForKey("message") as NSString == "网络出故障啦!" {
                print("网络出故障啦!")
            }else {
                if result.objectForKey("login") as Int == 0 {
                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "userId")
                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "accessToken")
         
                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "name")
                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "image")
                    NSUserDefaults.standardUserDefaults().setValue(0, forKey: "gender")
                    NSUserDefaults.standardUserDefaults().setValue("", forKey: "description")
                }
            }
        }
    }
    // MARK: - refresh function
    func refresh(flag:Int, longit:NSString, latit:NSString, startindex:NSString, endindex:NSString, userid:NSString, relationship:Int) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        dispatch_group_async(group, queue, {
           
        })
        dispatch_group_notify(group, queue, {
            var dic = ["tag":flag,"longitude":longit, "latitude":latit, "accessToken":"", "userId":userid,"startIndex":"0","endIndex":"20", "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "relationship":relationship] as NSDictionary
            AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
//                print(result)
                if result.objectForKey("message") as NSString == "网络出故障啦!" {
                    print("网络故障")
                    self.activityIndicator.stopAnimating()
                }else {
                    print(result.objectForKey("message"))
                    
                    self.voteArray = NSMutableArray(array: result.objectForKey("list") as NSArray)
                    self.tableView.reloadData()
                
                }
                self.activityIndicator.stopAnimating()
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - allowVote protocol
    func allowVote(count: Int, dic: NSDictionary) {
     voteArray.replaceObjectAtIndex(count, withObject: dic)
     tableView.reloadData()
    }
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVoteDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if voteArray.count > 0 {
               let vote = voteArray[indexPath.row] as NSDictionary
                (segue.destinationViewController as VoteDetailViewController).voteDetail = vote
                (segue.destinationViewController as VoteDetailViewController).lastPageCellCount = indexPath.row
                (segue.destinationViewController as VoteDetailViewController).delegate = self
            }
               
            }
        }
        
    }
   // MARK: - Table View 自定义cell protocol
    func sendNumber(num: Int) {
        var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var userDetailVc = storyBoard.instantiateViewControllerWithIdentifier("userDetail") as UserDetailTableViewController
        let voteFeed = voteArray[num] as NSDictionary
        userDetailVc.contactId = voteFeed["authorId"] as NSString
        self.navigationController?.pushViewController(userDetailVc, animated: true)
    
    }
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteArray.count
       
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("voteCell", forIndexPath: indexPath) as VoteTableViewCell
        cell.statusImageView.image = UIImage(named:"status_green")
        if voteArray.count > 0 {
            let voteItem = self.voteArray.objectAtIndex(indexPath.row) as NSDictionary
            cell.num = indexPath.row
            cell.delegate = self
            cell.voteTitle.text = voteItem["title"] as? NSString
            
            if voteItem["allowVote"] as Int == 0 {
                cell.statusImageView.image = UIImage(named: "status_gray")
            }

            if voteItem["authorName"] as NSString == "" {
                cell.voteAuthor.setTitle("游客", forState: UIControlState.Normal)
            }else {
                cell.voteAuthor.setTitle(voteItem["authorName"] as? NSString, forState: UIControlState.Normal)
            }
            cell.authorID = voteItem["authorId"] as? NSString
            var imageUrl = NSURL(string: voteItem["voteImage"] as NSString)
            cell.voteImage?.sd_setImageWithURL(imageUrl)
            var widthEqualZeroConstraint = NSLayoutConstraint(
                item: cell.voteImage!,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Width,
                multiplier: 0,
                constant: 0
            )
            var defaultWidthConstraint = NSLayoutConstraint(
                item: cell.voteImage!,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Width,
                multiplier: 0,
                constant: 83
            )
            if voteItem["voteImage"] as NSString == "" {
                cell.voteImage!.removeConstraints(cell.voteImage!.constraints())
                cell.voteImage!.addConstraint(widthEqualZeroConstraint)
            }
            else{
                cell.voteImage!.removeConstraints(cell.voteImage!.constraints())
                cell.voteImage!.addConstraint(defaultWidthConstraint)
            }
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if pushrelationship == 0 {
            if pushuserId == NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString {
            return true
            }
        }
        return false
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            print(NSUserDefaults.standardUserDefaults().objectForKey("accessToken"))
            print("*******")
            var deleteItem = NSArray(objects: indexPath)
            var deleteDic = ["method":"delete","deviceId:":UIDevice.currentDevice().identifierForVendor.UUIDString, "voteId":(voteArray.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("Id") as NSString,  "acessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
            AFnetworkingJS.uploadJson(deleteDic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/vote/", resultBlock: { (result) -> Void in
                print(result.valueForKey("message"))
//                if result.valueForKey("messgae") as NSString == "网络出故障啦!" {
//                    print("网络故障")
//                }else {
                    self.voteArray.removeObjectAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths(deleteItem, withRowAnimation: UITableViewRowAnimation.Fade)
//                }
            })
           
        }
            
    }
    //    func configureCell(cell: VoteTableViewCell, atIndexPath indexPath: NSIndexPath) {
    //        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
    //        cell.voteTitle.text = object.valueForKey("voteTitle") as? String
    //        cell.voteAuthor.setTitle(object.valueForKey("voteAuthor") as? String, forState: UIControlState.Normal)
    //        var imageUrl = NSURL(string: object.valueForKey("voteImage") as NSString)
    //        cell.voteImage.sd_setImageWithURL(imageUrl)
    //    }
    
    // MARK: - Fetched results controller
    
    //    var fetchedResultsController: NSFetchedResultsController {
    //        if _fetchedResultsController != nil {
    //            return _fetchedResultsController!
    //        }
    //
    //        let fetchRequest = NSFetchRequest()
    //        // Edit the entity name as appropriate.
    //        let entity = NSEntityDescription.entityForName("Votes", inManagedObjectContext: self.managedObjectContext!)
    //        fetchRequest.entity = entity
    //
    //        // Set the batch size to a suitable number.
    //        fetchRequest.fetchBatchSize = 20
    //
    //        // Edit the sort key as appropriate.
    //        let sortDescriptor = NSSortDescriptor(key: "voteAuthor", ascending: false)
    //        let sortDescriptors = [sortDescriptor]
    //
    //        fetchRequest.sortDescriptors = [sortDescriptor]
    //
    //        // Edit the section name key path and cache name if appropriate.
    //        // nil for section name key path means "no sections".
    //        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    //        aFetchedResultsController.delegate = self
    //        _fetchedResultsController = aFetchedResultsController
    //
    //    	var error: NSError? = nil
    //    	if !_fetchedResultsController!.performFetch(&error) {
    //    	     // Replace this implementation with code to handle the error appropriately.
    //    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //             //println("Unresolved error \(error), \(error.userInfo)")
    //    	     abort()
    //    	}
    //
    //        return _fetchedResultsController!
    //    }
    //    var _fetchedResultsController: NSFetchedResultsController? = nil
    //
    //    func controllerWillChangeContent(controller: NSFetchedResultsController) {
    //        self.tableView.beginUpdates()
    //    }
    //
    //    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    //        switch type {
    //            case .Insert:
    //                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    //            case .Delete:
    //                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    //            default:
    //                return
    //        }
    //    }
    //
    //    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    //        switch type {
    //            case .Insert:
    //                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    //            case .Delete:
    //                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    //            case .Update:
    //                var cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath!)! as VoteTableViewCell
    //                self.configureCell(cellToUpdate, atIndexPath: indexPath!)
    //            case .Move:
    //                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    //                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    //            default:
    //                return
    //        }
    //    }
    //
    //    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //        self.tableView.endUpdates()
    //    }
    
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }
    */
    
}

