//
//  NewVoteTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreLocation
class NewVoteTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIAlertViewDelegate, CLLocationManagerDelegate {
    //notification

    var locationManager = CLLocationManager()
    var tokenDefult = NSUserDefaults.standardUserDefaults()
    var pickerArray = NSArray()
    var selectedImageView = UIImageView()
    var optionArray = NSMutableArray()
    var taptextfield = UITextField()
    var longitude:NSString = ""
    var latitude:NSString = ""
//    var optionCellRowCount = 1
    var optionCellRowCountArray = ["1", "2"] as NSMutableArray
    var titleTagArray = NSMutableArray()
    var optionTagArray = NSMutableArray()
    
    @IBOutlet var sendButton: UIButton!
    
    @IBAction func cancelOnclick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBAction func sendVoteOnclick(sender: UIButton) {
//        sender.setTitle("...", forState: UIControlState.Normal)
        sender.enabled = false
        sendMessage()
        
    }
 //MARK: -发送的内容function
    func  sendMessage() {
        let titlecell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        
        var titleTextView = titlecell?.contentView.viewWithTag(102) as UITextView//问题
        var titleImageView = titlecell?.contentView.viewWithTag(101) as UIImageView
        var data = UIImageJPEGRepresentation(titleImageView.image, 0.75)
        var encodeStr = ""
        if titleImageView.image == UIImage(named: "dummyImage") {
            encodeStr = ""
        }else {
         encodeStr = data.base64EncodedStringWithOptions(nil)
        }
        for index in 0...optionCellRowCountArray.count - 1 {
            var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1))
            let optionTitle = cell?.contentView.viewWithTag(102) as UITextField
            var imageview = cell?.contentView.viewWithTag(101) as UIImageView
            var data1 = UIImageJPEGRepresentation(imageview.image, 0.75)
            var encodeStr1 = data1.base64EncodedStringWithOptions(nil)
            var dic = NSMutableDictionary()
            if optionTitle.text != "" {
                dic.setObject(optionTitle.text, forKey: "title")
                if imageview.image == UIImage(named: "dummyImage") {
//                 dic.setObject("", forKey: "image")
                    optionArray.addObject(dic)
                }else {
                dic.setObject(encodeStr1, forKey: "image")
                optionArray.addObject(dic)
                }
                
            }
        }
        var pickerCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as UITableViewCell?
        var picker = pickerCell?.contentView.viewWithTag(101) as UIPickerView
        var selectPicker = pickerArray.objectAtIndex(picker.selectedRowInComponent(0)) as NSString
        var date = NSDate(timeIntervalSinceNow: (8 + selectPicker.doubleValue * 24) * 60 * 60)
        var dateArray = date.description.componentsSeparatedByString(" ") as NSArray
//        var senddic = ["title":titleTextView.text, "voteImage":encodeStr,"option":optionArray,"latitude":latitude,"longitude":longitude,"expireDate":dateArray.firstObject as NSString,"accessToken":tokenDefult.valueForKey("accessToken") as NSString,"allowComment":1] as NSDictionary
        var sendDic = NSDictionary()
        if encodeStr == "" {
        sendDic = ["title":titleTextView.text,  "allowVote":true, "allowComment":true,  "option":optionArray]
        }else {
           sendDic = ["title":titleTextView.text, "image":encodeStr, "allowVote":true, "allowComment":true,  "option":optionArray]
        }
//        print(sendDic)
        if (sendDic["title"] as NSString != "") {
            var str = "http://voteage.com:8000/api/votes/"
            AFnetworkingJS.uploadJson(sendDic, url: str) { (result) -> Void in
                print(result)
                print(result.valueForKey("message"))
                if (result as NSDictionary).objectForKey("message") == nil {
                    var alert = UIAlertView(title: "", message: "发起成功", delegate: self, cancelButtonTitle: "点击查看")
                    self.sendButton.enabled = true
                    self.sendButton.setTitle("发送", forState: UIControlState.Normal)
                    alert.show()
                }else {
                    self.sendButton.enabled = true
                    self.sendButton.setTitle("发送", forState: UIControlState.Normal)
                    var alert = UIAlertView(title: "温馨提示", message: "发送失败", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
            }
            }
        }else{
            var alert = UIAlertView(title: "温馨提示", message: "请输入问题", delegate: nil, cancelButtonTitle: "确定")
            sendButton.enabled = true
            self.sendButton.setTitle("发送", forState: UIControlState.Normal)
            alert.show()
            
        }
        

    }
    
    // MARK: - 定位
//    func updateLocation(locationManager: CLLocationManager) {
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 100.0
//        locationManager.delegate = self
//        if UIDevice.currentDevice().systemVersion >= "8.0" {
//            locationManager.requestWhenInUseAuthorization()
//        }
//        locationManager.startUpdatingLocation()
//    }
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        print(error)
//        sendMessage()
//    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var loc = locations.last as CLLocation
        var coord = loc.coordinate
//        refresh(2, longit:coord.latitude.description, latit: coord.longitude.description)
        longitude = coord.longitude.description
        latitude  = coord.latitude.description
        sendMessage()
        manager.stopUpdatingLocation()
    }
    // MARK: - alertview
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.tabBarController?.selectedIndex = 0
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
           
        })

    }
   // MARK: -   Picker view
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count;
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return (pickerArray.objectAtIndex(row) as NSString)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        var now = NSDate(timeIntervalSinceNow: 8 * 60 * 60)
        var array = now.description.componentsSeparatedByString(" ") as NSArray
        print(array.firstObject as NSString)
        pickerArray = ["1", "3", "5", "10", "15", "30", "60", "90"]
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        optionArray.removeAllObjects()
        sendButton.enabled = true
        sendButton.setTitle("发送", forState: UIControlState.Normal)
        
    }
    
    func tap(sender:UITapGestureRecognizer) {
        selectedImageView = sender.view as UIImageView
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册", "清除")
        photoSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        var btnTitle = actionSheet.buttonTitleAtIndex(buttonIndex)
        if buttonIndex != actionSheet.cancelButtonIndex {
            if btnTitle.hasPrefix("拍照") {
                getPhotoByType("camera")
            }
            if btnTitle.hasPrefix("相册") {
                getPhotoByType("album")
            }
            if btnTitle.hasPrefix("清除") {
                selectedImageView.image = UIImage(named: "dummyImage")
            }
            
        }
    }
    func getPhotoByType(type:NSString) {
        if (type == "camera" && !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            print("不支持摄像头")
            return
        }
        var  picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if(type == "album") {
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }else{
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera) {
            if(CGSizeEqualToSize(UIScreen.mainScreen().currentMode!.size, CGSizeMake(640, 960)) || CGSizeEqualToSize(UIScreen.mainScreen().currentMode!.size, CGSizeMake(320, 480))) {
                picker.videoQuality = UIImagePickerControllerQualityType.TypeLow
            }else {
                picker.videoQuality = UIImagePickerControllerQualityType.TypeMedium
            }
        }
        presentViewController(picker, animated: true) { () -> Void in
            
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker .dismissViewControllerAnimated(false, completion: { () -> Void in
        })
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        
        var imageAskView = cell?.contentView.viewWithTag(101) as UIImageView
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        //        print(rowCount)
        var imageAnswerView = cell1?.contentView.viewWithTag(101) as UIImageView
        //      var index = tableView.indexPathForCell(supercell) as NSIndexPath?
        //      print(cell1?.frame)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var resizeImg = ImageUtil.imageFitView(image, fitforSize: CGSizeMake(400, 400))
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.selectedImageView.image = resizeImg
            })
        })
        
    }
 
    // MARK: -   Text view
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidChange(textView: UITextView) {
        var str = NSMutableString(string: textView.text)
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        let placeholder = cell?.contentView.viewWithTag(103) as UILabel
        let countlabeL = cell?.contentView.viewWithTag(104) as UILabel
        if(textView.text != ""){
            placeholder.hidden = true
        }else{
            placeholder.hidden = false
        }
        
        if(str.length <= 50){
            textView.text = str
        }else{
            str.deleteCharactersInRange(NSMakeRange(50, str.length - 50))
            textView.text = str
        }
        
        countlabeL.text = (50 - str.length).description
    }
    // MARK: -   Textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        taptextfield = textField
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return optionCellRowCountArray.count + 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch (indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteTitleCell", forIndexPath: indexPath) as UITableViewCell
            
            let image = cell.contentView.viewWithTag(101) as UIImageView
            let titleImageTapGesture = UITapGestureRecognizer(target: self, action: "tap:")
            image.userInteractionEnabled = true
            image.addGestureRecognizer(titleImageTapGesture)
    
            let textView = cell.contentView.viewWithTag(102) as UITextView
            textView.delegate = self
            
        case 1:
            if indexPath.row == optionCellRowCountArray.count{
            cell = tableView.dequeueReusableCellWithIdentifier("addOptionCell", forIndexPath: indexPath) as UITableViewCell
            }else {
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteOptionCell", forIndexPath: indexPath) as UITableViewCell
            let image = cell.contentView.viewWithTag(101) as UIImageView
            let optionImageTapGesture = UITapGestureRecognizer(target: self, action: "tap:")
            image.userInteractionEnabled = true
            image.addGestureRecognizer(optionImageTapGesture)
            let textField = cell.contentView.viewWithTag(102) as UITextField
            textField.delegate = self
            }
            
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteExpireDateCell", forIndexPath: indexPath) as UITableViewCell
            let expireDatePickerView = cell.contentView.viewWithTag(101) as UIPickerView
            expireDatePickerView.delegate = self
            expireDatePickerView.dataSource = self
            default:
            break
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == optionCellRowCountArray.count{
                if optionCellRowCountArray.count < 5 {
                optionCellRowCountArray.addObject("1")
                tableView.reloadData()
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: optionCellRowCountArray.count - 1, inSection: 1)) as UITableViewCell?
                    let textf = cell?.contentView.viewWithTag(102) as UITextField
                    textf.becomeFirstResponder()
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            return 100
        case 1:
            return 55
        case 2:
            return 195
        default:
            return 100
        }
    }
    func createTag(tagArray: NSArray, tag:Int, str:Selector, chosen:Int) ->UIView {
        var footerView = UIView()
        if tagArray.count != 0 {
            footerView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            var rowCount = 0
            var colCount = 0
            var x = CGFloat()
            var y = CGFloat()
            var width = (self.view.frame.width - 40) / 3
            for i in 0...tagArray.count-1 {
                var tagButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                x = CGFloat(10 * (colCount + 1)) + width * CGFloat(colCount)
                y = CGFloat(5 + 35 * rowCount)
                tagButton.frame = CGRectMake(x, y, width, 30)
                colCount++
                // Next line
                if colCount > 2 {
                    colCount = 0
                    rowCount++
                }
                if chosen == 0 {
                tagButton.setTitle(tagArray.objectAtIndex(i)["title"] as NSString, forState: UIControlState.Normal)
                }else{
                      tagButton.setTitle(tagArray.objectAtIndex(i) as NSString, forState: UIControlState.Normal)
                }
                
                tagButton.tag = i + tag
                tagButton.layer.masksToBounds = true
                tagButton.layer.cornerRadius = tagButton.frame.height / 2
                tagButton.backgroundColor = UIColor.whiteColor()
                tagButton.addTarget(self, action:str, forControlEvents: UIControlEvents.TouchUpInside)
                footerView.addSubview(tagButton)
            }
        }
        return footerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch (section) {
        case 0:
            return createTag(titleTagArray, tag: 1, str:"btn:", chosen:0)
        case 1:
            return createTag(optionTagArray, tag: 10000, str:"btnAnswer:", chosen:1)
        default:
            return UIView()
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch (section) {
        case 0:
            let height = ceil(Double(titleTagArray.count) / 3) * 40
            return CGFloat(height)
        case 1:
            let height =  ceil(Double(optionTagArray.count) / 3) * 40
            return CGFloat(height)
        default:
            return 15
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1 {
            if optionCellRowCountArray.count > 2 && indexPath.row < optionCellRowCountArray.count {
            return true
        }
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var deleteItem = NSArray(objects: indexPath)
            self.optionCellRowCountArray.removeObjectAtIndex(indexPath.row)
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection: 1)) as UITableViewCell?
            let imgView = cell?.contentView.viewWithTag(101) as UIImageView
            imgView.image = UIImage(named: "dummyImage")
            let textfield = cell?.contentView.viewWithTag(102) as UITextField
            textfield.text = ""
            tableView.deleteRowsAtIndexPaths(deleteItem, withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func btn(btn:UIButton) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        let textView = cell?.contentView.viewWithTag(102) as UITextView
        let label = cell?.contentView.viewWithTag(103) as  UILabel
        label.hidden = true
        textView.text = btn.currentTitle
        var i = btn.tag - 1
        optionTagArray = titleTagArray.objectAtIndex(i)["option"] as NSMutableArray
        tableView.reloadData()
    }
    
    func btnAnswer(btn:UIButton) {
        taptextfield.text = taptextfield.text.stringByAppendingString(optionTagArray.objectAtIndex(btn.tag - 10000) as NSString)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
