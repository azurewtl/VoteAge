//
//  HasVoteTableViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/26.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class HasVoteTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,  UIActionSheetDelegate, CLLocationManagerDelegate, sendInfoDelegate{
    var locationManager = CLLocationManager()
    @IBAction func optionButton(sender: UIBarButtonItem) {
        var sheet  = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "附近", "热点")
        sheet.showInView(self.view)
    }
    var relationship = 0
    var allowvoteDic = NSMutableDictionary()
    var tokenDefult = NSUserDefaults.standardUserDefaults()
    var managedObjectContext: NSManagedObjectContext? = nil
    var voteArray = NSMutableArray()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var dragDownactivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var dragImageView = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            updateLocation(locationManager)
            self.title = "附近"
        }
        if buttonIndex == 2 {
            self.title = "热点"
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
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc = locations.last as CLLocation
        var coord = loc.coordinate
        print(coord.latitude)
        print(coord.longitude)
        manager.stopUpdatingLocation()
    }

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragImageView.hidden = false
        dragImageView.image = UIImage(named:"dragUp")
    }
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -140 {
            dragImageView.image = UIImage(named:"dragDown")
        }
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.dragImageView.hidden = true
        if scrollView.contentOffset.y < -140 {
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let group = dispatch_group_create()
            self.dragDownactivity.startAnimating()
            dispatch_group_async(group, queue, {
                scrollView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0)
            })
            dispatch_group_notify(group, queue, {
                var dic = ["accessToken":self.tokenDefult.objectForKey("accessToken") as NSString, "userId":self.tokenDefult.objectForKey("userId") as NSString,"startIndex":"0","endIndex":"20", "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "relationship":self.relationship] as NSDictionary
                AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
                    print(result)
                    if result.valueForKey("message") as NSString == "网络出故障啦！" {
                        print("网络故障")
                    }else {
                        print(result.valueForKey("message"))
                        
                        self.voteArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
                        self.tableView.reloadData()
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
        self.tabBarController?.tabBar.hidden = true
        //        print(UIDevice.currentDevice().identifierForVendor.UUIDString)
        activityIndicator.frame = CGRectMake(130, 200, 50, 50)
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 5
        self.view.addSubview(activityIndicator)
        //下拉刷新
        dragDownactivity.frame = CGRectMake(150, -24, 50, 50)
        self.view.addSubview(dragDownactivity)
        dragImageView.frame = CGRectMake(150, -44, 50, 50)
        dragImageView.image = UIImage(named: "dragUp")
        self.view.addSubview(dragImageView)
        dragImageView.highlighted = true
        var ceshi:Int = 1
        if(ceshi == 1){
            //            var str = "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/"
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let group = dispatch_group_create()
            dispatch_group_async(group, queue, {
                self.activityIndicator.startAnimating()
                
            })
            dispatch_group_notify(group, queue, {
            
                var dic = ["accessToken":self.tokenDefult.objectForKey("accessToken") as NSString, "userId":self.tokenDefult.objectForKey("userId") as NSString,"startIndex":"0","endIndex":"20", "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "relationship":self.relationship] as NSDictionary
                AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
                    print(result)
                    if result.valueForKey("message") as NSString == "网络出故障啦！" {
                        print("网络故障")
                    }else {
                        print(result.valueForKey("message"))
                        
                        self.voteArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
                        self.tableView.reloadData()
                    }
                    self.activityIndicator.stopAnimating()
                }
                
            })
            
            
        }else{
            //            var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
            //            var data1 = NSData(contentsOfFile: path1!)
            //
            //            var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            //            voteArray = votedic.objectForKey("hotlist") as NSMutableArray
        }
    }
    // MARK: - protocol
    var vote = NSMutableDictionary()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "hasVotePush" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                if voteArray.count > 0 {
                    let vote = NSMutableDictionary(dictionary:voteArray[indexPath.row] as NSMutableDictionary)
                    (segue.destinationViewController as VoteDetailViewController).voteDetail = vote
                    print("**")
                    print(vote)
                }
                
            }
        }
        
    }
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
        if voteArray.count > 0 {
            cell.num = indexPath.row
            cell.delegate = self
            let voteItem = self.voteArray.objectAtIndex(indexPath.row) as NSDictionary
            cell.voteTitle.text = voteItem["title"] as? NSString
            if voteItem["authorName"] as NSString == "" {
                cell.voteAuthor.setTitle("游客", forState: UIControlState.Normal)
            }else {
                cell.voteAuthor.setTitle(voteItem["authorName"] as? NSString, forState: UIControlState.Normal)
            }
            cell.authorID = voteItem["authorId"] as? NSString
            if voteItem["voteImage"] as NSString == "" {
                cell.voteImage?.image = UIImage(named: "dummyImage")
            }else {
                var imageUrl = NSURL(string: voteItem["voteImage"] as NSString)
                cell.voteImage?.sd_setImageWithURL(imageUrl)
            }
        }
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
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


