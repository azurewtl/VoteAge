//
//  DetailViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
protocol allowVoteDelegate {
    func allowVote(count:Int, dic:NSDictionary)
}
class VoteDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextViewDelegate, UIAlertViewDelegate, ImagesendDelegate{
    var delegate = allowVoteDelegate?()
    var lastPageCellCount = 0
    var emptyIndex = 0//纪录option图片的个数
    // MARK: - configureView
    var section1CellCount = 1//投票评论cell的section里cell的数目
    var voteDetail = NSDictionary()
    // For textField above keyboard
    var showKeyboardTextView = true // If the textview about keyboard needed to be shown
    var keyboardView = CommentView()
    var commtArray = NSMutableArray()
    var commentCellHeightArray = NSMutableArray()
    // For vote count
    var selectIndex = -1
    var menCount = CGFloat()
    var womenCount = CGFloat()
    var optionArray = NSMutableArray()
    // For countdown

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var voteImage: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
//    @IBOutlet weak var waiveButton: UIButton!
    @IBOutlet weak var voteSegment: UISegmentedControl!
    
    @IBAction func optionItemOnClick(sender: UIBarButtonItem) {
        var selectSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "分享", "生成二维码")
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
                    
                    var percentage = CGFloat(optionArray[row]["menCount"] as Int)
                    if menCount == 0 {
                        percentage = 0
                    }else {
                    percentage = percentage / menCount
                    }
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        cell!.optionProgress.setProgress(Float(percentage), animated: true)
                    })
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
                    var percentage = CGFloat(optionArray[row]["womenCount"] as Int)
                    if womenCount == 0 {
                        percentage = 0
                    }else {
                    percentage = percentage / womenCount
                    }
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        cell!.optionProgress.setProgress(Float(percentage), animated: true)
                    })
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
        default:
            println("Segment Control Error")
        }
    }

    // MARK: - 分享评论按钮
    
    @IBAction func commentOnClick(sender: UIBarButtonItem) {
   
        showKeyboardTextView = true
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
         keyboardView.keyboardTextView.becomeFirstResponder()
        if commentCellHeightArray.count >= 1 {
            var cellheight = commentCellHeightArray.objectAtIndex(0) as CGFloat
            var totalheight = cell!.frame.origin.y - cell!.frame.height - 20
            if totalheight < cell?.frame.origin.y {
                tableView.contentOffset.y = totalheight
            }else {
                tableView.contentOffset.y = totalheight
            }
            
        }else {
            tableView.contentOffset.y = cell!.frame.origin.y - cell!.frame.height - 20
        }
    }
    // MARK: - viewDidload

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.showsVerticalScrollIndicator = false        
        commtArray = NSMutableArray(array: voteDetail.valueForKey("comment") as NSArray)
        if commtArray.count > 0 {
        for item in commtArray {
            var str = (item as NSDictionary).objectForKey("content") as NSString
            var label1 = UILabel()
            label1.numberOfLines = 0
            label1.frame = CGRectMake(0, 0, self.view.frame.width - 16, 0)
            label1.text = str.stringByRemovingPercentEncoding
            label1.sizeToFit()
            self.commentCellHeightArray.addObject(label1.frame.height + 50)
        }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardDidHidden:", name: UIKeyboardWillHideNotification, object: nil)
        var nib = NSBundle.mainBundle().loadNibNamed("CommentView", owner: nil, options: nil) as NSArray
        keyboardView = nib.objectAtIndex(0) as CommentView
       
        keyboardView.backgroundColor = UIColor.whiteColor()
        keyboardView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 50)
        keyboardView.layer.borderWidth = 1
        keyboardView.layer.borderColor = UIColor.grayColor().CGColor
         keyboardView.keyboardTextView.returnKeyType = UIReturnKeyType.Done
  
         keyboardView.keyboardTextView.frame = CGRectMake(0, 0, 0.75 * keyboardView.frame.width, 50)
         keyboardView.keyboardTextView.delegate = self
         keyboardView.keyboardTextView.layer.borderColor = UIColor.grayColor().CGColor
         keyboardView.keyboardTextView.layer.borderWidth = 1
         keyboardView.keyboardButton.addTarget(self, action: "sendInform", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(keyboardView)
//
        
        self.configureView()
        for item in optionArray {
            if (item as NSDictionary)["image"]! as? NSString == nil {
                emptyIndex++
            }
        }
        if(voteDetail["allowVote"] as Int == 1){
            section1CellCount = 2
            tableView.reloadData()
        }else{
            self.voteTotalperson()
//            waiveButton.hidden = true
        }
    }
    
    func configureView() {
        if(voteTitle != nil) {
            voteTitle.text = voteDetail.objectForKey("title") as NSString
            if (voteDetail["image"]! as? NSString != nil)  {
            var imageUrl = NSURL(string: voteDetail["image"] as NSString)
                 voteImage.sd_setImageWithURL(imageUrl)
               
            }else {
                self.view.addConstraint(NSLayoutConstraint(item: voteImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: 0))
            }
            self.optionArray = NSMutableArray(array: voteDetail.objectForKey("option") as NSArray)
            var dateStr = voteDetail.objectForKey("expireDate") as NSString
            var startStr = voteDetail.objectForKey("createDate") as NSString
          
            dateStr = dateStr.stringByReplacingOccurrencesOfString("T", withString: "")
            dateStr = dateStr.stringByReplacingOccurrencesOfString("Z", withString: "")
            dateStr = dateStr.stringByReplacingOccurrencesOfString("-", withString: "")
            dateStr = dateStr.stringByReplacingOccurrencesOfString(":", withString: "")
            var format = NSDateFormatter()
            format.dateFormat = "yyyyMMddHHmmss"
            var date = format.dateFromString(dateStr)
            var date1 = NSDate(timeInterval: 8 * 60 * 60, sinceDate: date!)
//            print(date1)
            var dd = NSDate(timeIntervalSinceNow: 8 * 60 * 60)
            var inteval = date1.timeIntervalSinceDate(dd)
            if (Double(inteval) / 24 / 3600) >= 1 {
            expireDate.text = NSString(format: "还剩%d天", (Int(Double(inteval) / 24 / 3600)))
            }else if (Double(inteval) / 24 / 3600) > 0 {
                expireDate.text = NSString(format: "还剩%d小时", (Int(Double(inteval) /  3600)))
            }else if (Double(inteval) / 3600) > 0{
                expireDate.text = NSString(format: "还剩%d分钟", (Int(Double(inteval) /  60)))

            }else if (Double(inteval) / 60) > 0{
                expireDate.text = NSString(format: "还剩%d分钟", Int(inteval))
            }else {
                expireDate.text = "已经截止"
            }
            
            for option in optionArray{
                menCount += CGFloat(option["menCount"] as Int)
                womenCount += CGFloat(option["womenCount"] as Int)
               
            }
             voteCount.text = NSString(format: "%d人", Int(menCount) + Int(womenCount))
         
        }
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
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
            var publishContent = ShareSDK.content("VoteAge", defaultContent: "VoteAge", image: ShareSDK.imageWithPath(savepath), title: "VoteAge", url: NSString(format: "http://www.voteage.com:8000/static/webapp/?voteid=%d", voteDetail["id"] as Int), description: "这是一条测试信息", mediaType: SSPublishContentMediaTypeNews)
            
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
        if buttonIndex == 2 {
            let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let qrcVc = storyBoard.instantiateViewControllerWithIdentifier("makeqrc") as MakeqrcViewController
            qrcVc.qrcStr = NSString(format: "http://www.voteage.com:8000/static/webapp/?voteid=%d", voteDetail["id"] as Int)
            self.navigationController?.pushViewController(qrcVc, animated: true)
        }
    }
    // MARK: - keyborad 通知中心的两个方法
    func handleKeyboardDidShow(notification:NSNotification) {
        var dic = notification.userInfo as NSDictionary!
        if showKeyboardTextView == true {
            var keyboardHeight = dic.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue().size.height
            var animationValue = dic.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as NSValue
            var duration = NSTimeInterval()
            animationValue.getValue(&duration)
            UIView.beginAnimations("animal", context: nil)
            UIView.setAnimationDuration(duration)
            keyboardView.frame = CGRectMake(0, self.view.frame.height - keyboardHeight - 50, self.view.frame.width, 50)
            UIView.commitAnimations()
            keyboardView.hidden = false
        }
        
    }
    func handleKeyboardDidHidden(notification:NSNotification) {
        tableView.contentOffset = CGPointZero
        keyboardView.hidden = true
    }
    //MARK: - 发送评论
    func sendInform() {
        keyboardView.hidden = true
         keyboardView.keyboardTextView.resignFirstResponder()
        var commtDic = NSMutableDictionary()
         commtDic.setValue(NSUserDefaults.standardUserDefaults().objectForKey("userId"), forKey: "userId")
        commtDic.setValue( keyboardView.keyboardTextView.text, forKey: "content")
        var dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var dateStr = dateformatter.stringFromDate(NSDate())
        commtDic.setValue(dateStr, forKey: "createDate")
        commtArray.insertObject(commtDic, atIndex: 0)
//        var dic = ["userId":NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString, "voteId":voteDetail["Id"] as NSString, "content": keyboardView.keyboardTextView.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!,"deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "accessToken":NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as NSString] as NSDictionary
        var dic = ["content":keyboardView.keyboardTextView.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!]
//        var str = "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/addComment"
        AFnetworkingJS.uploadJson(dic, url: NSString(format: "http://voteage.com:8000/api/votes/%d/comment/", voteDetail["id"] as Int)) { (result) -> Void in
            
           
        }
        //自适应的label1，别无他用
        var label1 = UILabel()
        label1.numberOfLines = 0
        label1.frame = CGRectMake(0, 0, self.view.frame.width - 16, 0)
        label1.text =  keyboardView.keyboardTextView.text
        label1.sizeToFit()
        commentCellHeightArray.insertObject(label1.frame.height + 50, atIndex: 0)
        tableView.reloadData()
        keyboardView.keyboardTextView.text = ""
        
    }
     func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == tableView {
             keyboardView.keyboardTextView.resignFirstResponder()
        }
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - waiveButton
    
//    @IBAction func waiveButton(sender: UIButton) {
//        sender.hidden = true
//        self.voteTotalperson()
//        section1CellCount = 1
//        tableView.reloadData()
//    }
    
    
    // MARK: - totalVoted
    func voteTotalperson() {
        let rowCount = tableView.numberOfRowsInSection(0)
        var cell: OptionTableViewCell?
        tableView.allowsSelection = false
        for row in 0...rowCount-1{
            cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
            if ((cell) != nil) {
                var percentage = CGFloat(optionArray[row]["menCount"] as Int)
                percentage += CGFloat(optionArray[row]["womenCount"] as Int)
                if menCount + womenCount == 0 {
                    percentage = 0
                }else{
                percentage = percentage / (menCount + womenCount)
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    cell!.optionProgress.setProgress(Float(percentage), animated: true)
                })

                
                }
                let perInt = Int(percentage * 100)
                cell?.optionDetail.text = perInt.description + "%"
            }
        }
    }
    

    
    // MARK: - Table View
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            NSUserDefaults.standardUserDefaults().setObject(1, forKey: "gender")
            voteAndrefreshSingle()
        }
        if buttonIndex == 2 {
            NSUserDefaults.standardUserDefaults().setObject(2, forKey: "gender")
            voteAndrefreshSingle()
        }
    }
    // MARK:- 投票ing
    func votedOnclick(btn:UIButton) {
        if NSUserDefaults.standardUserDefaults().objectForKey("gender") as Int == 0 {
            var alert = UIAlertView(title: "提示", message: "未登录时请选择性别，选好后将不能更改。。", delegate: self, cancelButtonTitle: "再想想", otherButtonTitles: "男", "女")
            alert.show()
        }else {
            voteAndrefreshSingle()
        }
    }
    func voteAndrefreshSingle() {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        let voteButton = cell?.contentView.viewWithTag(101) as ActivityButton
        
        var deviceId = UIDevice.currentDevice().identifierForVendor.UUIDString
        if selectIndex == -1 {
            var alert = UIAlertView()
            alert.message = "请选择"
            alert.show()
            let gloabalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let time64 = dispatch_time(DISPATCH_TIME_NOW, (Int64)(NSEC_PER_SEC))
            dispatch_after(time64, gloabalqueue, { () -> Void in
                alert.dismissWithClickedButtonIndex(0, animated: true)
            })
        }else {
        voteButton.juhua.startAnimating()//菊花开始转动
            
        var optionDic = optionArray.objectAtIndex(selectIndex) as NSDictionary
//        var dic = ["voteId":voteDetail.objectForKey("Id") as NSString,"optionId":optionDic.objectForKey("optionId") as NSString,"gender":NSUserDefaults.standardUserDefaults().objectForKey("gender") as Int,"deviceId":deviceId,"accessToken":((NSUserDefaults.standardUserDefaults()).valueForKey("accessToken")) as NSString] as NSDictionary
            var voteDic = ["optionid":optionDic.objectForKey("id") as Int, "gender":NSUserDefaults.standardUserDefaults().objectForKey("gender") as Int]
        AFnetworkingJS.uploadJson(voteDic, url: NSString(format: "http://voteage.com:8000/api/votes/%d/submit/", voteDetail["id"] as Int)) { (result) -> Void in
          
//            var getSingleDic = ["deviceId":UIDevice.currentDevice().identifierForVendor.UUIDString, "voteId":self.voteDetail.objectForKey("Id") as NSString] as NSDictionary
//            AFnetworkingJS.uploadJson(getSingleDic, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appVote/vote/", resultBlock: { (result) -> Void in
//                print(result)
//                print(result.valueForKey("message"))
//                if result.valueForKey("status") as Int == 1 {
//                    self.menCount = 0
//                    self.womenCount = 0
//                    self.voteDetail = result.valueForKey("list") as NSDictionary
//                    self.configureView()
//                    self.waiveButton.hidden = true
//                    self.voteSegment.selectedSegmentIndex = 1;
//                    let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectIndex, inSection: 0)) as OptionTableViewCell?
//                    cell?.checkImageView.hidden = true
//                    voteButton.juhua.stopAnimating()
//                    self.section1CellCount = 1
//                    self.tableView.reloadData()
//                    self.voteTotalperson()
//                    self.delegate?.allowVote(self.lastPageCellCount,dic: self.voteDetail)
//                }else {
//                    print("error")
//                    voteButton.juhua.stopAnimating()
//                }
//            })
            AFnetworkingJS.netWorkWithURL(NSString(format: "http://voteage.com:8000/api/votes/%d/", self.voteDetail["id"] as Int), resultBlock: { (result) -> Void in
               
                if result.valueForKey("message") == nil {
                    self.menCount = 0
                    self.womenCount = 0
                    self.voteDetail = result as NSDictionary
                    self.configureView()
//                    self.waiveButton.hidden = true
                    self.voteSegment.selectedSegmentIndex = 1;
                    let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.selectIndex, inSection: 0)) as OptionTableViewCell?
                    cell?.checkImageView.hidden = true
                    voteButton.juhua.stopAnimating()
                    self.section1CellCount = 1
                    self.tableView.reloadData()
                    self.voteTotalperson()
                    self.delegate?.allowVote(self.lastPageCellCount,dic: self.voteDetail)
                }
            })
        }
        }
    }
    // MARK:- tableview
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.optionArray.count
        case 1:
            return section1CellCount
        case 2:
            return commtArray.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 53
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
            cell.optionTitle.text = dicAppear.objectForKey("title") as NSString
            cell.delegate = self
            cell.imagenumber = indexPath.row
            cell.checkImageView.hidden = true
            
            if (dicAppear["image"]! as? NSString != nil)  {
            var imageUrl = NSURL(string: dicAppear["image"] as NSString)
            cell.optionImage?.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "dummyImage"))
           }
            if emptyIndex == optionArray.count {
               cell.optionImage!.addConstraint(NSLayoutConstraint(item: cell.optionImage!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 0, constant: 0))
            }else {
           
            }
            
            return cell
        }else if indexPath.section == 1 {
            if section1CellCount == 2 {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("voteCell") as UITableViewCell
                    var button = cell.contentView.viewWithTag(101) as ActivityButton
                    button.setTitle("投票", forState: UIControlState.Normal)
                    button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    button.addTarget(self, action: "votedOnclick:", forControlEvents: UIControlEvents.TouchUpInside)
                    
                    return cell
                }else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("toolBarCell", forIndexPath: indexPath) as UITableViewCell
                    var toolBar = cell.contentView.viewWithTag(101) as UIToolbar
                    return cell
                }
                
            }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("toolBarCell", forIndexPath: indexPath) as UITableViewCell
            var toolBar = cell.contentView.viewWithTag(101) as UIToolbar
            return cell
            }
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as UITableViewCell
        var userButton = cell.contentView.viewWithTag(101) as UIButton
        var label = cell.contentView.viewWithTag(102) as UILabel

        if commtArray.count > 0 {
            
           
            var str = (commtArray.objectAtIndex(indexPath.row) as NSMutableDictionary).objectForKey("createDate") as NSString
            str = str.stringByReplacingOccurrencesOfString("T", withString: " ")
            str = str.stringByReplacingOccurrencesOfString("Z", withString: "")
             userButton.setTitle(str, forState: UIControlState.Normal)
            label.text = ((commtArray.objectAtIndex(indexPath.row) as NSMutableDictionary).objectForKey("content") as NSString).stringByRemovingPercentEncoding
        }
        return cell
    }
    
    
    func setSelect(number: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var imageViewController = storyBoard.instantiateViewControllerWithIdentifier("imgView") as ImageViewController
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as OptionTableViewCell?
        imageViewController.imgCount = number
        imageViewController.optionArr = voteDetail.objectForKey("option") as NSArray
        imageViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(imageViewController, animated: true) { () -> Void in
        }
    }
    
    // MARK: - Option Cell Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
           
            for index in 0...optionArray.count - 1 {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as OptionTableViewCell?
                cell?.checkImageView.hidden = true
            }
            let selectcell = tableView.cellForRowAtIndexPath(indexPath) as OptionTableViewCell?
             selectcell?.checkImageView.hidden = false
            selectIndex = indexPath.row
        
    }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "titleImage" {
            
            (segue.destinationViewController as ImageViewController).photoView.image = self.voteImage.image
            (segue.destinationViewController as ImageViewController).imgCount = -1
        }
//        if segue.identifier == "getUserInfo" {
//            var targetCell = (sender!.superview! as UIView!).superview! as UITableViewCell
//            var index = tableView.indexPathForCell(targetCell)
//         
//            if (commtArray.objectAtIndex(index!.row) as NSMutableDictionary).objectForKey("userName") as NSString == "" {
//                print(1)
//            }else {
//            (segue.destinationViewController as UserDetailTableViewController).contactId = (commtArray.objectAtIndex(index!.row) as NSMutableDictionary).objectForKey("userId") as NSString
//            }
//        }
        
    }
    
}