//
//  DetailViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreLocation

class VoteDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, CLLocationManagerDelegate, UITextViewDelegate, ImagesendDelegate{
   
    // MARK: - configureView
    var voteDetail = NSDictionary()
    // For textField above keyboard
    var showKeyboardTextView = true // If the textview about keyboard needed to be shown
    var keyboardView = UIView()
    var keyboardButton = UIButton()
    var keyboardTextView = UITextView()
    var commtArray = NSMutableArray()
    var commentCellHeightArray = NSMutableArray()
    // For vote count
    var menCount = CGFloat()
    var womenCount = CGFloat()
    var optionArray = NSMutableArray()
    // For countdown
    var time = NSTimeInterval()
    var timer = NSTimer()
    var locationManager = CLLocationManager()
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var voteImage: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var waiveButton: UIButton!
    @IBOutlet weak var voteSegment: UISegmentedControl!
    
    @IBAction func optionItemOnClick(sender: UIBarButtonItem) {
        var selectSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "收藏", "定位")
        selectSheet.showInView(self.view)
    }
    // MARK: - Segment Control
    
    @IBAction func voteSegment(sender: UISegmentedControl) {
        
        let rowCount = tableView.numberOfRowsInSection(0)
        
        switch(sender.selectedSegmentIndex) {
        case 0: // men only
            var cell: OptionTableViewCell?
            for row in 0...rowCount-1{
                cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    
                    var percentage = CGFloat((optionArray[row]["menCount"] as NSString).floatValue)
                    if menCount == 0 {
                        percentage = 0
                    }else {
                    percentage = percentage / menCount
                    }
                    cell?.optionProgress.setProgress(Float(percentage), animated: true)
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
            
        case 1: // everyone
            self.voteTotalperson()
            
        case 2: // women only
            var cell: OptionTableViewCell?
            for row in 0...rowCount-1{
                cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    var backTab = CGRectMake(54, 0, self.view.frame.width - 54, 54)
                    var percentage = CGFloat((optionArray[row]["womenCount"] as NSString).floatValue)
                    if womenCount == 0 {
                        percentage = 0
                    }else {
                    percentage = percentage / womenCount
                    }
                    cell?.optionProgress.setProgress(Float(percentage), animated: true)
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
        default:
            println("Segment Control Error")
        }
    }

    // MARK: - 分享评论按钮
    
    @IBAction func shareOnClick(sender: UIBarButtonItem) {
        showKeyboardTextView = false
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var viewimage = UIGraphicsGetImageFromCurrentImageContext()
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewimage, nil, nil, nil)
        
        var imageviewdata = UIImagePNGRepresentation(viewimage) as NSData
        var documentdirectory = paths.objectAtIndex(0) as NSString
        var picName = "screenShow.png"
        var savepath = documentdirectory.stringByAppendingPathComponent(picName)
        imageviewdata.writeToFile(savepath, atomically: true)
        var publishContent = ShareSDK.content("VoteAge", defaultContent: "VoteAge", image: ShareSDK.imageWithPath(savepath), title: "VoteAge", url: "http://www.voteage.com", description: "这是一条测试信息", mediaType: SSPublishContentMediaTypeNews)
        
        ShareSDK.showShareActionSheet(nil, shareList: nil, content: publishContent, statusBarTips: true, authOptions: nil, shareOptions: nil, result: { (var type:ShareType, var state:SSResponseState, var info:ISSPlatformShareInfo?, var error:ICMErrorInfo?, var end:Bool) -> Void in
            
            if Int(state.value) == 2{
                var alert = UIAlertView(title: "提示", message: "分享失败", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                self.view.addSubview(alert)
            }else if Int(state.value) == 1 {
                var alert = UIAlertView(title: "提示", message: "分享成功", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                self.view.addSubview(alert)
            }
        })
    }
    
    @IBAction func commentOnClick(sender: UIBarButtonItem) {
        showKeyboardTextView = true
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        keyboardTextView.becomeFirstResponder()
        if commentCellHeightArray.count >= 1 {
            var cellheight = commentCellHeightArray.objectAtIndex(0) as CGFloat
            var totalheight = cell!.frame.origin.y - keyboardView.frame.origin.y + cell!.frame.height + cellheight + 25
            if totalheight < cell?.frame.origin.y {
                tableView.contentOffset.y = totalheight
            }else {
                tableView.contentOffset.y = cell!.frame.origin.y - 64
            }
            
        }else {
            tableView.contentOffset.y =  cell!.frame.origin.y - keyboardView.frame.origin.y + cell!.frame.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var dic = ["voteId":voteDetail["Id"] as NSString,"startIndex":"0","endIndex":"10"] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/getCommentList/") { (result) -> Void in
            print(result)
            print(result.valueForKey("message"))
            if (result.valueForKey("list") as NSArray).count > 0 {
            self.commtArray = NSMutableArray(array: result.valueForKey("list") as NSArray)
                for item in (result.valueForKey("list") as NSArray) {
                    var str = (item as NSDictionary).objectForKey("content") as NSString
                    var label1 = UILabel()
                    label1.numberOfLines = 0
                    label1.frame = CGRectMake(0, 0, self.view.frame.width - 16, 0)
                    label1.text = str
                    label1.sizeToFit()
                    self.commentCellHeightArray.addObject(label1.frame.height + 40)
                }
                
            self.tableView.reloadData()
            }
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        self.tabBarController?.tabBar.hidden = true
        keyboardView.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        keyboardView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 70)
        self.view.addSubview(keyboardView)
        keyboardButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        keyboardTextView.frame = CGRectMake(0, 0, 0.75 * keyboardView.frame.width, 70)
        keyboardTextView.delegate = self
        keyboardTextView.font = UIFont.boldSystemFontOfSize(15)
        keyboardTextView.layer.borderWidth = 0.5
        keyboardTextView.layer.borderColor = UIColor.whiteColor().CGColor
        keyboardTextView.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
        keyboardView.addSubview(keyboardTextView)
        keyboardButton.frame = CGRectMake(keyboardTextView.frame.width, 0, 0.25 * keyboardView.frame.width,
            70)
        keyboardButton.setTitle("发表", forState: UIControlState.Normal)
        keyboardButton.addTarget(self, action: "sendInform", forControlEvents: UIControlEvents.TouchUpInside)
        keyboardView.addSubview(keyboardButton)

        self.configureView()
        if(voteDetail["allowVote"] as Int == 1){
            tableView.allowsSelection = false
            waiveButton.userInteractionEnabled = false
            voteSegment.userInteractionEnabled = false
            timeCount()
        }else{
            self.voteTotalperson()
            waiveButton.hidden = true
        }
    }
    
    func configureView() {
        if(voteTitle != nil) {
            voteTitle.text = voteDetail.objectForKey("title") as NSString
            var imageUrl = NSURL(string: voteDetail["voteImage"] as NSString)
            voteImage.sd_setImageWithURL(imageUrl)
            self.optionArray = voteDetail.objectForKey("option") as NSMutableArray
            expireDate.text = NSString(format:"截止日期:%@", voteDetail.objectForKey("expireDate") as NSString)
            voteCount.text = NSString(format: "%@人", voteDetail.objectForKey("voteTotal") as NSString)
            
            for option in optionArray{
                menCount += CGFloat((option["menCount"] as NSString).floatValue)
                womenCount += CGFloat((option["womenCount"] as NSString).floatValue)
            }
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        keyboardTextView.resignFirstResponder()
        keyboardView.hidden = true
        scrollView.contentOffset.y = -64
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            keyboardView.hidden = true
            tableView.contentOffset.y = -64
        }
        return true
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
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 2 { // GPS Location
            updateLocation(locationManager)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc = locations.last as CLLocation
        var coord = loc.coordinate
        print(coord.latitude)
        print(coord.longitude)
        manager.stopUpdatingLocation()
    }
    
    func handleKeyboardDidShow(notification:NSNotification) {
        var dic = notification.userInfo as NSDictionary!
        if showKeyboardTextView == true {
            var keyboardHeight = dic.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue().size.height
            var animationValue = dic.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as NSValue
            var duration = NSTimeInterval()
            animationValue.getValue(&duration)
            UIView.beginAnimations("animal", context: nil)
            UIView.setAnimationDuration(duration)
            keyboardView.frame = CGRectMake(0, self.view.frame.height - keyboardHeight - 70, self.view.frame.width, 70)
            UIView.commitAnimations()
            keyboardView.hidden = false
        }
        
    }
    //MARK: - 发送评论
    func sendInform() {
        keyboardView.hidden = true
        keyboardTextView.resignFirstResponder()
        var commtDic = NSMutableDictionary()
        commtDic.setValue(keyboardTextView.text, forKey: "content")
        commtArray.insertObject(commtDic, atIndex: 0)
        var dic = ["userId":NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString, "voteId":voteDetail["Id"] as NSString, "content":keyboardTextView.text,"deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/addComment") { (result) -> Void in
            print(result)
            print(result.valueForKey("message"))
        }
        //自适应的label1，别无他用
        var label1 = UILabel()
        label1.numberOfLines = 0
        label1.frame = CGRectMake(0, 0, self.view.frame.width - 16, 0)
        label1.text = keyboardTextView.text
        label1.sizeToFit()
        commentCellHeightArray.insertObject(label1.frame.height + 40, atIndex: 0)
        tableView.reloadData()
        keyboardTextView.text = ""
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - waiveButton
    
    @IBAction func waiveButton(sender: UIButton) {
        sender.hidden = true
        self.voteTotalperson()
    }
    
    func timeCount() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeFire", userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func timeFire(){
        time++
        waiveButton .setTitle((3 - time).description + "秒后可以投票", forState: UIControlState.Normal)
        if(time > 2){
            time = 0
            waiveButton.userInteractionEnabled = true
            waiveButton .setTitle("放弃投票,查看结果", forState: UIControlState.Normal)
            self.tableView.allowsSelection = true
            voteSegment.userInteractionEnabled = true
            timer.invalidate()
        }
        
    }
    
    // MARK: - totalVoted
    func voteTotalperson() {
        let rowCount = tableView.numberOfRowsInSection(0)
        var cell: OptionTableViewCell?
        tableView.allowsSelection = false
        for row in 0...rowCount-1{
            cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
            if ((cell) != nil) {
                var percentage = CGFloat((optionArray[row]["menCount"] as NSString).floatValue)
                percentage += CGFloat((optionArray[row]["womenCount"] as NSString).floatValue)
                if menCount + womenCount == 0 {
                    percentage = 0
                }else{
                percentage = percentage / menCount + womenCount
                }
                cell?.optionProgress.setProgress(Float(percentage), animated: false)
                let perInt = Int(percentage * 100)
                cell?.optionDetail.text = perInt.description + "%"
            }
        }
    }
    

    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.optionArray.count
        case 1:
            return 1
        case 2:
            return commtArray.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 55
        case 1:
            return 45
        case 2:
            return commentCellHeightArray.objectAtIndex(indexPath.row) as CGFloat
//            return 60
        default:
            return 55
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as OptionTableViewCell
            var dicAppear = self.optionArray.objectAtIndex(indexPath.row) as NSDictionary
            cell.optionTitle.text = dicAppear.objectForKey("option") as NSString
            cell.delegate = self
            cell.imagenumber = indexPath.row
            
            if dicAppear["image"] as NSString == "" {
                cell.optionImage.image = UIImage(named: "dummyImage")
            }else {
                var imageUrl = NSURL(string: dicAppear["image"] as NSString)
                cell.optionImage?.sd_setImageWithURL(imageUrl)
            }

            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("toolBarCell", forIndexPath: indexPath) as UITableViewCell
            var toolBar = cell.contentView.viewWithTag(101) as UIToolbar
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as UITableViewCell
        var label = cell.contentView.viewWithTag(102) as UILabel
        label.text = (commtArray.objectAtIndex(indexPath.row) as NSDictionary).objectForKey("content") as NSString
        return cell
    }
    
    func setSelect(number: Int) {
        var imageViewController = ImageViewController()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as OptionTableViewCell?
        imageViewController.photoView.image = cell?.optionImage.image
        imageViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(imageViewController, animated: true) { () -> Void in
        }
    }
    
    // MARK: - Option Cell Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        var optionDic = optionArray.objectAtIndex(indexPath.row) as NSDictionary
        var dic = ["voteId":voteDetail.objectForKey("Id") as NSString,"optionId":optionDic.objectForKey("optionId") as NSString,"gender":1,"deviceId":deviceId,"accessToken":((NSUserDefaults.standardUserDefaults()).valueForKey("accessToken")) as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/votesubmit") { (result) -> Void in
            print(result)
//            print("***")
//            print(((NSUserDefaults.standardUserDefaults()).valueForKey("accessToken")) as NSString)
            print(result.valueForKey("message"))
            var getSingleDic = ["deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "voteId":self.voteDetail.objectForKey("Id") as NSString] as NSDictionary
            AFnetworkingJS.uploadJson(getSingleDic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/vote/", resultBlock: { (result) -> Void in
                print(result)
                print(result.valueForKey("message"))
                self.voteDetail = result.valueForKey("list") as NSDictionary
                self.configureView()
                self.voteTotalperson()
                self.waiveButton.hidden = true
                self.voteSegment.selectedSegmentIndex = 1;
            })
        }
           
        
    }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "titleImage" {
            
            (segue.destinationViewController as ImageViewController).photoView.image = self.voteImage.image
        }
    }
    
}