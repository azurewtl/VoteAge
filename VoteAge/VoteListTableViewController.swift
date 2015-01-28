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
    var startIndex = 0
    var endIndex = 5
    var managedObjectContext: NSManagedObjectContext? = nil
    var voteArray = NSMutableArray()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var dragDownactivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var dragImageView = UIImageView()
    
    @IBOutlet var loadActivityView: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
        self.activityIndicator.startAnimating()
        updateLocation(locationManager)
        self.title = "附近"
        }
        if buttonIndex == 2 {
           self.title = "热点"
            self.activityIndicator.startAnimating()
            refresh(1, longit: "", latit: "", startindex:"0", endindex:"5")
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
        refresh(2, longit:coord.latitude.description, latit: coord.longitude.description,startindex:"0", endindex:"5")
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
                    self.startIndex += 5
                    self.endIndex += 5
                        var dic = ["accessToken":"", "userId":"","startIndex":self.startIndex.description,"endIndex":self.endIndex.description, "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString] as NSDictionary
                        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
                            print(result)
                            if result.valueForKey("message") as NSString == "网络出故障啦!" {
                                print("网络故障")
                            }else {
                                print(result.valueForKey("message"))
                                for item in result.valueForKey("list") as NSArray {
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
                var dic = ["accessToken":"", "userId":"","startIndex":"0","endIndex":"5", "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString] as NSDictionary
                AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
                    print(result)
                    if result.valueForKey("message") as NSString == "网络出故障啦!" {
                        print("网络故障")
                    }else {
                        print(result.valueForKey("message"))
                        
                        self.voteArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
                        self.tableView.reloadData()
                        self.startIndex = 0
                        self.endIndex = 0
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
        self.view.addSubview(dragDownactivity)
        dragImageView.frame = CGRectMake(150, -50, 50, 50)
        dragImageView.center = CGPointMake(view.center.x, dragImageView.center.y)
        dragImageView.image = UIImage(named: "dragUp")
        self.view.addSubview(dragImageView)
        dragImageView.highlighted = true
        refresh(0, longit: "", latit: "", startindex:"0", endindex:"5")
        
    }
    // MARK: - 判断token是否匹配
    func getLoginStatus() {
        var dic = ["userId":(NSUserDefaults.standardUserDefaults().objectForKey("userId")) as NSString, "accessToken":(NSUserDefaults.standardUserDefaults().objectForKey("accessToken")) as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/getLoginStatus") { (result) -> Void in
            print(result)
            if result.valueForKey("message") as NSString == "网络出故障啦!" {
                print("网络出故障啦!")
            }else {
                if result.valueForKey("login") as Int == 0 {
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
    func refresh(flag:Int, longit:NSString, latit:NSString, startindex:NSString, endindex:NSString) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        dispatch_group_async(group, queue, {
           
        })
        dispatch_group_notify(group, queue, {
            var dic = ["tag":flag,"longitude":longit, "latitude":latit, "accessToken":"", "userId":"","startIndex":startindex,"endIndex":endindex, "deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString] as NSDictionary
            AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getVoteList/") { (result) -> Void in
                print(result)
                if result.valueForKey("message") as NSString == "网络出故障啦!" {
                    print("网络故障")
                }else {
                    print(result.valueForKey("message"))
                    
                    self.voteArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
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
        var imageUrl = NSURL(string: voteItem["voteImage"] as NSString)
        if voteItem["voteImage"] as NSString == "" {
                cell.contentView.addConstraint(NSLayoutConstraint(item: cell.voteImage!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: cell.contentView, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: 0))
        }else {
        cell.voteImage?.sd_setImageWithURL(imageUrl)
            }
          
        }
        return cell
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

