//
//  VoteListViewController.swift
//  VoteAge
//
//  Created by caiyang on 15/3/4.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
class VoteListViewController: UIViewController, CLLocationManagerDelegate, sendInfoDelegate, allowVoteDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

 
    @IBAction func hotTap(sender: UITapGestureRecognizer) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func meTap(sender: UITapGestureRecognizer) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString == "" {
            var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
            self.presentViewController(logVc, animated: true) { () -> Void in
            }
        }else {
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.tabBarController?.selectedIndex = 1
        }
    }
    @IBAction func plusOnclick(sender: UIButton) {
        if NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString == "" {
            var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var logVc:RegisterTableViewController =  storyboard.instantiateViewControllerWithIdentifier("login") as RegisterTableViewController
            self.presentViewController(logVc, animated: true) { () -> Void in
            }
        }else {
            var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            var newvoteVc = storyBoard.instantiateViewControllerWithIdentifier("newVote") as NewVoteTableViewController
            self.presentViewController(newvoteVc, animated: true) { () -> Void in
                
            }
        }

    }
    
    @IBOutlet var hotImageView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    var homePageArray = NSArray()
    var next = false
    var page = 1
    var sheetView = UIView()
    var collectionView:UICollectionView!
    var newScroll:AutoScrollView!
    var locationManager = CLLocationManager()
    
    @IBAction func optionButton(sender: UIBarButtonItem) {
        if sheetView.alpha == 0 {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                 self.sheetView.alpha = 1
            })
           
//            tableView.scrollEnabled = false
        }else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.sheetView.alpha = 0
            })
            
        }
    }
    var pushrelationship = -1
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
    
     func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        dragImageView.hidden = false
        dragImageView.image = UIImage(named:"dragUp")
    }
     func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -140 {
            dragImageView.image = UIImage(named:"dragDown")
        }else{
            dragImageView.image = UIImage(named:"dragUp")
        }
        
    }
    // MARK: -上拉加载
     func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height{
            loadActivityView.hidden = false
            loadActivityView.startAnimating()
            if pushuserId == "" {
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
                }, completion: { (finish) -> Void in
                    if self.next == true {
                        self.page++;
                        AFnetworkingJS.netWorkWithURL(NSString(format: "http://voteage.com:8000/api/votes/?page=%d", self.page), resultBlock: { (result) -> Void in
                            if (result as NSDictionary).objectForKey("message") == nil {
                                
                               
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
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0)
                    }, completion: { (finish) -> Void in
                        if self.next == true {
                            self.page++;
                            var idd = (self.pushuserId as NSString).integerValue
                            AFnetworkingJS.netWorkWithURL(NSString(format: "http://voteage.com:8000/api/votes/?page=%d&creatorid=%d", self.page,idd), resultBlock: { (result) -> Void in
                                if (result as NSDictionary).objectForKey("message") == nil {
                                
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

            }
            
            
        }else {
            loadActivityView.stopAnimating()
        }
        
        
    }
    // MARK: -下拉刷新
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
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
            if pushuserId == "" {
            dispatch_group_async(group, queue, {
                scrollView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0)
            })
            dispatch_group_notify(group, queue, {
                var url = "http://voteage.com:8000/api/votes/"
                AFnetworkingJS.netWorkWithURL(url, resultBlock: { (result) -> Void in
                    //                    print(result)
                    if (result as NSDictionary).objectForKey("message") == nil {
                        self.voteArray = NSMutableArray(array: result.objectForKey("results") as NSArray)
                        if result.valueForKey("next")! as? NSString != nil {
                            self.next = true
                        }else {
                            self.next = false
                            
                        }
                        self.tableView.reloadData()
                        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
                        self.dragDownactivity.stopAnimating()
                        
                    }
                    
                })
                
            })
            }else {
                dispatch_group_async(group, queue, {
                    scrollView.contentInset = UIEdgeInsetsMake(120, 0, 0, 0)
                })
                dispatch_group_notify(group, queue, {
                    var url = NSString(format: "http://voteage.com:8000/api/votes/?creatorid=%d", (self.pushuserId as NSString).integerValue)
                    AFnetworkingJS.netWorkWithURL(url, resultBlock: { (result) -> Void in
                        //                    print(result)
                        if (result as NSDictionary).objectForKey("message") == nil {
                            self.voteArray = NSMutableArray(array: result.objectForKey("results") as NSArray)
                            if result.valueForKey("next")! as? NSString != nil {
                                self.next = true
                            }else {
                                self.next = false
                                
                            }
                            self.tableView.reloadData()
                            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
                            self.dragDownactivity.stopAnimating()
                            
                        }
                        
                    })
                    
                })
            }
            
        }
    }
    // MARK: -加载界面
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    func homePage() {
       AFnetworkingJS.netWorkWithURL("http://voteage.com:8000/api/homepage", resultBlock: { (result) -> Void in
        if (result as NSDictionary).objectForKey("message") == nil {
            self.homePageArray = result["slider"] as NSArray
            var labelAr = NSMutableArray()
            var imgAr = NSMutableArray()
            for item in self.homePageArray {
                print("******")
                print(item)
                print("******")
                var imgStr = NSString(format: "http://voteage.com:8000%@", (item as NSDictionary).objectForKey("image") as NSString)
                imgAr.addObject(imgStr)
                labelAr.addObject((item as NSDictionary).objectForKey("title") as NSString)
            }
            self.newScroll.labelArray = NSArray(array: labelAr)
            //        newScroll.imageNames = ["voiceChina.jpg", "gloable.jpg", "tiger.jpg", "caijin.jpeg"]
            self.newScroll.imageUrls = NSArray(array: imgAr)
        }else {
            print("error")
        }
       })
    }
    func backOnclick() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.sheetView.alpha = 0
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加轮播图的背景view
        hotImageView.image = UIImage(named: "hot_green")
        bottomLabel.hidden = true
        self.navigationController?.delegate = self
        sheetView.frame = CGRectMake(0, 64, view.frame.width, view.frame.height - 64)
        sheetView.backgroundColor = UIColor(red: 0.45, green: 0.70, blue: 0.99, alpha: 1)
        sheetView.alpha = 0
        self.view.addSubview(sheetView)
        var backButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        backButton.frame = CGRectMake(0, sheetView.frame.height - 49, 49, 49)
        backButton.center = CGPointMake(sheetView.center.x, backButton.center.y)
        backButton.addTarget(self, action: "backOnclick", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setBackgroundImage(UIImage(named: "chacha"), forState: UIControlState.Normal)
        sheetView.addSubview(backButton)
        // UICollectionView
        collectionView = UICollectionView(frame: CGRectMake(0, 0, view.frame.width, sheetView.frame.height - 49), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.grayColor()
        sheetView.addSubview(collectionView)
        collectionView.registerClass(VoteListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "reuse")
        //轮播图
        newScroll = AutoScrollView(frame: CGRectMake(0, 0, collectionView.frame.width, collectionView.frame.height  - collectionView.frame.width))
       homePage()
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
        activityIndicator.frame = CGRectMake(0, 0, 50, 50)
        activityIndicator.center = view.center
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 5
        self.activityIndicator.startAnimating()
        tableView.tableHeaderView = UIView(frame: CGRectMake(0.1, 0.1, view.frame.width, 0.1))
        self.view.addSubview(activityIndicator)
        //下拉刷新
        dragDownactivity.frame = CGRectMake(150, -50, 50, 50)
        dragDownactivity.center.x = view.center.x
        tableView.tableHeaderView!.addSubview(dragDownactivity)
        dragImageView.frame = CGRectMake(150, -50, 50, 50)
        dragImageView.center = CGPointMake(view.center.x, dragImageView.center.y)
        dragImageView.image = UIImage(named: "dragUp")
        tableView.tableHeaderView!.addSubview(dragImageView)
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
        var storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var gameVc = storyBoard.instantiateViewControllerWithIdentifier("gameVC") as GameViewController
        self.presentViewController(gameVc, animated: true) { () -> Void in
        }
        
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
        UIView.animateWithDuration(0.5, animations: { () -> Void in
           self.sheetView.alpha = 0
        })
       
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
        return UIEdgeInsetsMake(collectionView.frame.height  - collectionView.frame.width, 1, 0, 1)
    }
    // MARK: - refresh function
    func refresh(flag:Int, longit:NSString, latit:NSString, startindex:NSString, endindex:NSString, userid:NSString, relationship:Int) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let group = dispatch_group_create()
        if pushuserId == "" {
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
 
        }else {
            dispatch_group_async(group, queue, {
                
            })
            dispatch_group_notify(group, queue, {
                var url = NSString(format: "http://voteage.com:8000/api/votes/?creatorid=%d", (self.pushuserId as NSString).integerValue)
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
        userDetailVc.contactId = voteFeed["creatorid"] as Int
        self.navigationController?.pushViewController(userDetailVc, animated: true)
        
    }
    // MARK: - Table View
     func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
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
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteArray.count
        
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
//     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        if pushrelationship == 0 {
//            if pushuserId == NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString {
//                return true
//            }
//        }
//        return false
//    }
//     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            var deleteItem = NSArray(objects: indexPath)
//            var deleteDic = ["method":"delete","deviceId:":UIDevice.currentDevice().identifierForVendor.UUIDString, "voteId":(voteArray.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("Id") as NSString,  "acessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
//            AFnetworkingJS.uploadJson(deleteDic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/vote/", resultBlock: { (result) -> Void in
//              
//                //                if result.valueForKey("messgae") as NSString == "网络出故障啦!" {
//                //                    print("网络故障")
//                //                }else {
//                self.voteArray.removeObjectAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths(deleteItem, withRowAnimation: UITableViewRowAnimation.Fade)
//                //                }
//            })
//            
//        }
//
//}
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


