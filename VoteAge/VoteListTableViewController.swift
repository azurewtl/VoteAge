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
class VoteListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, sendInfoDelegate, allowVoteDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate{
    var next = false
    var page = 1
    var sheetView = UIView()
    var collectionView:UICollectionView!
    var newScroll:AutoScrollView!
    var locationManager = CLLocationManager()
    
 
    
    @IBAction func optionButton(sender: UIBarButtonItem) {
        if sheetView.hidden == true {
           sheetView.hidden = false
           tableView.scrollEnabled = false
        }else {
            sheetView.hidden = true
            tableView.scrollEnabled = true
        }
    }
    var pushrelationship = -1
    var actionSheetTag = 0//1热点 2附近 0全部
    var longi:Double = 0//经度
    var lati:Double = 0//纬度
    var pushuserId = ""

    var managedObjectContext: NSManagedObjectContext? = nil
    var voteArray = NSMutableArray()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    var dragDownactivity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var dragImageView = UIImageView()
    
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var loadActivityView: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

//    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
//        if buttonIndex == 1 {
//        actionSheetTag = 1
//        self.activityIndicator.startAnimating()
//        updateLocation(locationManager)
//        self.title = "附近"
//        }
//        if buttonIndex == 2 {
//            actionSheetTag = 2
//           self.title = "热点"
//            self.activityIndicator.startAnimating()
//            if self.tabBarController?.selectedIndex == 0 {
//            refresh(1, longit: "", latit: "", startindex:"0", endindex:"20", userid:"", relationship:0)
//            }
//            if pushrelationship == 0 {
//                refresh(1, longit: "", latit: "", startindex:"0", endindex:"20", userid:pushuserId,relationship:0)
//            }
//            if pushrelationship == 2 {
//                refresh(1, longit: "", latit: "", startindex:"0", endindex:"20", userid:NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString,relationship:2)
//            }
//
//        }
//    }
   
 
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
                if self.next == true {
                self.page++;
                 AFnetworkingJS.netWorkWithURL(NSString(format: "http://voteage.com:8000/api/votes/?page=%d", self.page), resultBlock: { (result) -> Void in
                    if (result as NSDictionary).objectForKey("message") == nil {
                        print("*****")
                        print(result)
                        if result.valueForKey("next")! as? NSString != nil {
                            self.next = true
                        }else {
                            self.next = false
                          
                        }
                        for item in result.objectForKey("results") as NSArray {
                            self.voteArray.addObject(item as NSDictionary)
                        }
                        self.tableView.reloadData()
                    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
                    self.loadActivityView.hidden = true
                    }
                 })
                }else {
                    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
                    self.loadActivityView.stopAnimating()
                    self.loadActivityView.hidden = true
                    self.bottomLabel.hidden = false
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
            page = 1
            self.bottomLabel.hidden = true
            self.loadActivityView.stopAnimating()
            self.loadActivityView.hidden = true
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
                var url = "http://voteage.com:8000/api/votes/"
                AFnetworkingJS.netWorkWithURL(url, resultBlock: { (result) -> Void in
//                    print(result)
                    if (result as NSDictionary).objectForKey("message") == nil {
                    self.voteArray = NSMutableArray(array: result.objectForKey("results") as NSArray)
                    self.next = true
                    self.tableView.reloadData()
                    scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
                    self.dragDownactivity.stopAnimating()
                    
                    }

                })
                
            })
            
        }
    }
 // MARK: -加载界面
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if self.tabBarController?.selectedIndex == 0 {
           refresh(0, longit: "", latit: "", startindex:"0", endindex:"20", userid:pushuserId,relationship:0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加轮播图的背景view
        bottomLabel.hidden = true
        self.navigationController?.delegate = self
        sheetView.frame = self.view.frame
        sheetView.backgroundColor = UIColor.yellowColor()
        sheetView.hidden = true
        self.view.addSubview(sheetView)
        // UICollectionView
        
        collectionView = UICollectionView(frame: sheetView.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.grayColor()
        sheetView.addSubview(collectionView)
        collectionView.registerClass(VoteListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "reuse")
        //轮播图
        newScroll = AutoScrollView(frame: CGRectMake(0, 0, collectionView.frame.width, collectionView.frame.height  - collectionView.frame.width - 100))
        newScroll.labelArray = ["中国好声音，新一轮大战拉开", "创意项目和想法提供集资的平台和社区", "智取威虎山：让人惊心动魄的谍战大片", "柴静斥资百万调查揭开雾霾真相"];
        newScroll.imageNames = ["voiceChina.jpg", "gloable.jpg", "tiger.jpg", "caijin.jpeg"]
//       newScroll.imageUrls = ["http://m.meilijia.com/images/activity/rjds/m/banner-s.jpg", "http://www.meilijia.com/images/ad/iphone/1.jpg?v=0723", "http://m.meilijia.com/images/activity/rjds/m/banner.jpg"]
        
        newScroll.timeInterval = 3
        collectionView.addSubview(newScroll)
        newScroll.setTarget(self, action: "autoAction:")
        
        //设置分割线左边到头
        if tableView.respondsToSelector("setSeparatorInset:") {
        tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector("setLayoutMargins:") {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
      
        loadActivityView.hidden = true
        activityIndicator.frame = CGRectMake(0, 150, 50, 50)
        activityIndicator.center.x = view.center.x
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 5
        self.activityIndicator.startAnimating()
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
    // MARK: - 轮播图点击方法
    
    func autoAction(tap:Tap) {
        print(tap.flag)
    }
    // MARK: - collectionviewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reuse", forIndexPath: indexPath) as VoteListCollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        if indexPath.item == 0 {
        cell.backgroundImgaeView.image = UIImage(named: "22")
        }else if indexPath.item == 1 {
            cell.backgroundImgaeView.image = UIImage(named: "33")
        }
        else if indexPath.item == 2 {
            cell.backgroundImgaeView.image = UIImage(named: "11")
        }else if indexPath.item == 3 {
            cell.backgroundImgaeView.image = UIImage(named: "44")
        }
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        sheetView.hidden = true
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width / 2 - 1.5, collectionView.frame.width / 2 - 1.5)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(collectionView.frame.height  - collectionView.frame.width - 100, 1, 0, 1)
    }
    // MARK: - refresh function
    func refresh(flag:Int, longit:NSString, latit:NSString, startindex:NSString, endindex:NSString, userid:NSString, relationship:Int) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        
        dispatch_group_async(group, queue, {
           
        })
        dispatch_group_notify(group, queue, {

            var url = "http://voteage.com:8000/api/votes/"
            AFnetworkingJS.netWorkWithURL(url, resultBlock: { (result) -> Void in
//                print(result)
                if (result as NSDictionary).objectForKey("message") == nil {
                self.voteArray = NSMutableArray(array: result.objectForKey("results") as NSArray)
                    if result.valueForKey("next")! as? NSString != nil {
                        self.next = true
                    }
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                }else {
                    self.activityIndicator.stopAnimating()
                }
                
                
            })
            
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
//        var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        var userDetailVc = storyBoard.instantiateViewControllerWithIdentifier("userDetail") as UserDetailTableViewController
//        let voteFeed = voteArray[num] as NSDictionary
//        userDetailVc.contactId = voteFeed["authorId"] as NSString
//        self.navigationController?.pushViewController(userDetailVc, animated: true)
    
    }
    // MARK: - Table View
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.respondsToSelector("setSeparatorInset:") {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector("setLayoutMargins:") {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteArray.count
       
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("votecell") as VoteTableViewCell
        cell.statusImageView.backgroundColor = UIColor(red: 92 / 256, green: 96 / 256, blue: 225 / 256, alpha: 1)
        if voteArray.count > 0 {
            let voteItem = self.voteArray.objectAtIndex(indexPath.row) as NSDictionary
            cell.num = indexPath.row
            cell.delegate = self
            cell.voteTitle.text = voteItem["title"] as? NSString
            
            if voteItem["allowVote"] as Int == 0 {
                cell.statusImageView.backgroundColor = UIColor.grayColor()
            }

            if voteItem["creatorname"] as NSString == "" {
                cell.voteAuthor.setTitle("游客", forState: UIControlState.Normal)
            }else {
                cell.voteAuthor.setTitle(voteItem["creatorname"] as? NSString, forState: UIControlState.Normal)
            }
            cell.authorID = voteItem["creatorid"] as? NSString
        
            
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
            cell.voteImage?.image = nil
            if (voteItem["image"]! as? NSString != nil) {
                var imageUrl = NSURL(string: voteItem["image"] as NSString)
                cell.voteImage?.sd_setImageWithURL(imageUrl)
//                cell.voteImage!.removeConstraints(cell.voteImage!.constraints())
//                cell.voteImage!.addConstraint(widthEqualZeroConstraint)
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

