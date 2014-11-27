//
//  NewVoteTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class NewVoteTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //notification
    var selectedImageview = UIImageView()
    var chooseArray = NSMutableArray()
    var sendDic = NSMutableDictionary()
    //
    var edittextfield = false
    var taptextfield = UITextField()
    var rowCount = 1
    var recordArray = NSMutableArray()
    var footViewArray = NSMutableArray()
    var footAnswer = NSMutableArray()
    @IBAction func sendVote(sender: UIBarButtonItem) {
        
        sendDic.setObject("12345678", forKey: "voteID")
        sendDic.setObject("caiyang", forKey: "voteAuthorName")
        sendDic.setObject("373789", forKey: "voteAuthorID")
        sendDic.setObject(0, forKey: "hasVoted")
    
        var titlecell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        var titleimageview = titlecell?.contentView.viewWithTag(101) as UIImageView
        if(titleimageview.image != UIImage(named: "dummyImage")) {
        var titleimageData = UIImageJPEGRepresentation(titleimageview.image, 0.75)
//        print(titleimageData.length)
        }
        for index in 0...rowCount - 1 {
            var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1))
            let lastTextField = cell?.contentView.viewWithTag(102) as UITextField
            var imageview = cell?.contentView.viewWithTag(101) as UIImageView
//            if(imageview.image != UIImage(named: "dummyImage")) {
//                
//            var imageData = UIImageJPEGRepresentation(imageview.image, 0.75)
//               print(imageData.length)
//            }
            var dic = NSMutableDictionary()
            if lastTextField.text != "" {
                dic.setObject(lastTextField.text, forKey: "title")
                var num1 = arc4random() % 10 + 1
                var num2 = arc4random() % 10 + 1
                dic.setObject(Int(num1), forKey: "menCount")
                dic.setObject(Int(num2), forKey: "womenCount")
                chooseArray.addObject(dic)
                print(chooseArray.count)
            }
        }
        
        sendDic.setObject(chooseArray, forKey: "options")
        if (sendDic["voteTitle"] != nil && sendDic["options"] as NSArray != []) {
            NSNotificationCenter.defaultCenter().postNotificationName("sendVote", object: nil, userInfo: sendDic)
            self.navigationController!.tabBarController?.selectedIndex = 0
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var imageAskView = cell?.contentView.viewWithTag(101) as UIImageView
        var gesTure = UITapGestureRecognizer(target: self, action: "tap:")
        imageAskView.userInteractionEnabled = true
        imageAskView.addGestureRecognizer(gesTure)
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        
        var imageAnswerView = cell1?.contentView.viewWithTag(101) as UIImageView
        var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
        imageAnswerView.userInteractionEnabled = true
        imageAnswerView.addGestureRecognizer(gesTure1)
        
    }
    func tap(sender:UITapGestureRecognizer) {
        selectedImageview = sender.view as UIImageView
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
                selectedImageview.image = UIImage(named: "dummyImage")
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
            
            var resizeImg = ImageUtil.imageFitView(image, fitforSize: CGSizeMake(100, 100))
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.selectedImageview.image = resizeImg
            })
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return rowCount
            
        case 2:
            return 1
        default:
            return 0
        }
    }
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
        
        if(str.length <= 30){
            textView.text = str
        }else{
            str.deleteCharactersInRange(NSMakeRange(30, str.length - 30))
            textView.text = str
        }
        
        countlabeL.text = (30 - str.length).description
        sendDic.setObject(textView.text, forKey: "voteTitle")
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
//        var v = self.view.viewWithTag(5000)
//        for item in v!.subviews {
//            (item as UIButton).enabled = false
//        }
        edittextfield = true;
        taptextfield = textField
    }
    func textFieldDidEndEditing(textField: UITextField) {
//        var v = self.view.viewWithTag(5000)
//        for item in v!.subviews {
//            (item as UIButton).enabled = true
//        }
        edittextfield = false
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowCount-1, inSection: 1)) as UITableViewCell?
        let lastTextField = lastCell?.contentView.viewWithTag(102) as UITextField
        if(lastTextField.text != ""){
            if rowCount < 5 {
                rowCount++
            }
            var dic = NSMutableDictionary()
            dic.setObject(lastTextField.text, forKey: "title")
            var num1 = arc4random() % 10 + 1
            var num2 = arc4random() % 10 + 1
            dic.setObject(Int(num1), forKey: "menCount")
            dic.setObject(Int(num2), forKey: "womenCount")
            
        }
        tableView.reloadData()
        switch rowCount {
        case 2:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 3:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 4:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 5:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 6:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        default:
            return
        }
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch (indexPath.section) {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteTitleCell", forIndexPath: indexPath) as UITableViewCell
            let textv = cell.contentView.viewWithTag(102) as UITextView
            textv.delegate = self
            
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteOptionCell", forIndexPath: indexPath) as UITableViewCell
            let textfield = cell.contentView.viewWithTag(102) as UITextField
            textfield.delegate = self
            
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteExpireDateCell", forIndexPath: indexPath) as UITableViewCell
        default:
            break
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (indexPath.section) {
        case 0:
            return 100
        case 1:
            return 55
        default:
            return 195
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footView = UIView()
        
        if section == 0 {
            var rowCount = 0
            var colCount = 0
            footView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            //            footView.backgroundColor = UIColor.cyanColor()
            for index in 0...footViewArray.count-1 {
                var btn = UIButton.buttonWithType(UIButtonType.System) as UIButton
                btn.frame = CGRectMake(CGFloat(6 + colCount * 100), CGFloat(5 + 35 * rowCount), 95, 30)
                colCount++
                if colCount > 2 {
                    colCount = 0
                    rowCount++
                }
                
                btn.setTitle(footViewArray.objectAtIndex(index)["title"] as NSString, forState: UIControlState.Normal)
                btn.tag = index + 1
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = btn.frame.height / 2
                btn.backgroundColor = UIColor.whiteColor()
                btn.addTarget(self, action: "btn:", forControlEvents: UIControlEvents.TouchUpInside)
                footView.addSubview(btn)
            }
            
        }
        if section == 1 {
            var footView1 = UIView()
//            footView1.tag = 5000
            var rowCount = 0
            var colCount = 0
            if footAnswer.count != 0{
                footView1.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
                for index in 0...footAnswer.count - 1 {
                    var btn = UIButton.buttonWithType(UIButtonType.System) as UIButton
                    
                    btn.frame = CGRectMake(CGFloat(6 + colCount * 100), CGFloat(5 + 35 * rowCount), 95, 30)
                    colCount++
                    if colCount > 2 {
                        colCount = 0
                        rowCount++
                    }
                    btn.setTitle(footAnswer.objectAtIndex(index) as NSString, forState: UIControlState.Normal)
                    btn.tag = index + 10000
                    btn.layer.masksToBounds = true
                    btn.layer.cornerRadius = btn.frame.height / 2
                    btn.backgroundColor = UIColor.whiteColor()
                    btn.addTarget(self, action: "btnAnswer:", forControlEvents: UIControlEvents.TouchUpInside)
                    footView1.addSubview(btn)
                }
            }
            return footView1
        }
        return footView
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            var height = footViewArray.count / 3 * 40
            if(footViewArray.count % 3 != 0 && footViewArray.count / 3 < 1){
                return 40
            }else if(footViewArray.count % 3 == 0 && footViewArray.count / 3 >= 1) {
                return CGFloat(height)
            }else if(footViewArray.count % 3 != 0 && footViewArray.count / 3 >= 1){
                return CGFloat(height + 40)
            }
            
        }
        if section == 1 {
            var height = footAnswer.count / 3 * 40
            if(footAnswer.count % 3 != 0 && footAnswer.count / 3 < 1){
                return 40
            }else if(footAnswer.count % 3 == 0 && footAnswer.count / 3 >= 1) {
                return CGFloat(height)
            }else if(footAnswer.count % 3 != 0 && footAnswer.count / 3 >= 1){
                return CGFloat(height + 40)
            }
        }
        return 20
    }
    func clearAnswer() {
        chooseArray.removeAllObjects()
        for index in 0...rowCount - 1 {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1)) as UITableViewCell?
            let lastTextField = cell?.contentView.viewWithTag(102) as UITextField
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            lastTextField.text = ""
            imageAnswerView.image = UIImage(named: "dummyImage")
            tableView.reloadData()
        }
        rowCount = 1
        
    }
    func btn(btn:UIButton) {
        clearAnswer()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        let textView = cell?.contentView.viewWithTag(102) as UITextView
        let label = cell?.contentView.viewWithTag(103) as  UILabel
        label.hidden = true
        textView.text = btn.currentTitle
        sendDic.setObject(textView.text, forKey: "voteTitle")
        var i = btn.tag - 1
        footAnswer = footViewArray.objectAtIndex(i)["option"] as NSMutableArray
        tableView.reloadData()
    }
    func btnAnswer(btn:UIButton) {
        if edittextfield == false {
            let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowCount-1, inSection: 1)) as UITableViewCell?
            let lastTextField = lastCell?.contentView.viewWithTag(102) as UITextField
            lastTextField.text = footAnswer.objectAtIndex(btn.tag - 10000) as NSString
            
            //        if(lastTextField.text != ""){
            if rowCount < 5 {
                rowCount++
            }
            //        }
            tableView.reloadData()
        }else {
            taptextfield.text = taptextfield.text.stringByAppendingString(footAnswer.objectAtIndex(btn.tag - 10000) as NSString)
        }
       
        switch rowCount {
        case 2:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 3:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 4:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 5:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 6:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap:")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        default:
            return
        }
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
