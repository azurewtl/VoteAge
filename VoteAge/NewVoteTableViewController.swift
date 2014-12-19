//
//  NewVoteTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class NewVoteTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //notification
    var collectioncellCount = 1
    var pickerArray = NSArray()
    var selectedImageView = UIImageView()
    var optionArray = NSMutableArray()
    var voteFeedDictionary = NSMutableDictionary()
    var edittextfield = false
    var taptextfield = UITextField()
    var optionCellRowCount = 1
    var titleTagArray = NSMutableArray()
    var optionTagArray = NSMutableArray()
    @IBAction func sendVote(sender: UIBarButtonItem) {
        
        voteFeedDictionary.setObject("12345678", forKey: "voteID")
        voteFeedDictionary.setObject("caiyang", forKey: "voteAuthorName")
        voteFeedDictionary.setObject("373789", forKey: "voteAuthorID")
        voteFeedDictionary.setObject(0, forKey: "hasVoted")
        
        var titlecell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        var titleimageview = titlecell?.contentView.viewWithTag(101) as UIImageView
        if(titleimageview.image != UIImage(named: "dummyImage")) {
            var titleimageData = UIImageJPEGRepresentation(titleimageview.image, 0.75)
            //        print(titleimageData.length)
        }
        for index in 0...optionCellRowCount - 1 {
            var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 1))
            let optionTitle = cell?.contentView.viewWithTag(102) as UITextField
            var imageview = cell?.contentView.viewWithTag(101) as UIImageView
            var dic = NSMutableDictionary()
            if optionTitle.text != "" {
                dic.setObject(optionTitle.text, forKey: "title")
                var num1 = arc4random() % 10 + 1
                var num2 = arc4random() % 10 + 1
                dic.setObject(Int(num1), forKey: "menCount")
                dic.setObject(Int(num2), forKey: "womenCount")
                optionArray.addObject(dic)
            }
        }
        
        voteFeedDictionary.setObject(optionArray, forKey: "options")
        if (voteFeedDictionary["voteTitle"] != nil && voteFeedDictionary["options"] as NSArray != []) {
            NSNotificationCenter.defaultCenter().postNotificationName("sendVote", object: nil, userInfo: voteFeedDictionary)
            self.navigationController!.tabBarController?.selectedIndex = 0
        }
        
    }
    
    //pickerView
    
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
        pickerArray = ["1天", "3天", "5天", "10天", "15天", "30天", "60天", "90天"]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = true
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
            
            var resizeImg = ImageUtil.imageFitView(image, fitforSize: CGSizeMake(100, 100))
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.selectedImageView.image = resizeImg
            })
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        voteFeedDictionary.setObject(textView.text, forKey: "voteTitle")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        edittextfield = true;
        taptextfield = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Add empty option cell if user edit the last option cell
        edittextfield = false
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: optionCellRowCount-1, inSection: 1)) as UITableViewCell?
        let lastTextField = lastCell?.contentView.viewWithTag(102) as UITextField
        if(lastTextField.text != ""){
            if optionCellRowCount < 5 {
                optionCellRowCount++
            }
            var dic = NSMutableDictionary()
            dic.setObject(lastTextField.text, forKey: "title")
            var num1 = arc4random() % 10 + 1
            var num2 = arc4random() % 10 + 1
            dic.setObject(Int(num1), forKey: "menCount")
            dic.setObject(Int(num2), forKey: "womenCount")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
        case 1:
            return optionCellRowCount
        case 2:
            return 1
        case 3:
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
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteOptionCell", forIndexPath: indexPath) as UITableViewCell
            
            let image = cell.contentView.viewWithTag(101) as UIImageView
            let optionImageTapGesture = UITapGestureRecognizer(target: self, action: "tap:")
            image.userInteractionEnabled = true
            image.addGestureRecognizer(optionImageTapGesture)
            
            let textField = cell.contentView.viewWithTag(102) as UITextField
            textField.delegate = self
            
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteExpireDateCell", forIndexPath: indexPath) as UITableViewCell
            let expireDatePickerView = cell.contentView.viewWithTag(101) as UIPickerView
            expireDatePickerView.delegate = self
            expireDatePickerView.dataSource = self
            
        case 3:
            cell = tableView.dequeueReusableCellWithIdentifier("NewVoteAddCell", forIndexPath: indexPath) as UITableViewCell
            var collectionView = cell.contentView.viewWithTag(101) as UICollectionView
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.scrollEnabled = false
            collectionView.registerClass(VoteAddPersonCell.classForCoder(), forCellWithReuseIdentifier: "addperson")
            
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
        case 2:
            return 195
        case 3:
            var height = collectioncellCount / 4 * 90
            if(collectioncellCount % 4 != 0 && collectioncellCount / 4 < 1){
                return 90
            }else if(collectioncellCount % 4 == 0 && collectioncellCount / 4 >= 1) {
                return CGFloat(height)
            }
            return CGFloat(height + 90)
        default:
            return 100
        }
    }
    
    func createTag(tagArray: NSArray) ->UIView {
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
                tagButton.setTitle(tagArray.objectAtIndex(i)["title"] as NSString, forState: UIControlState.Normal)
                tagButton.tag = i + 1
                tagButton.layer.masksToBounds = true
                tagButton.layer.cornerRadius = tagButton.frame.height / 2
                tagButton.backgroundColor = UIColor.whiteColor()
                tagButton.addTarget(self, action: "btn:", forControlEvents: UIControlEvents.TouchUpInside)
                footerView.addSubview(tagButton)
            }
        }
        return footerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch (section) {
        case 0:
            return createTag(titleTagArray)
        case 1:
            return createTag(optionTagArray)
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
    
    // MARK: - Collection View
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectioncellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("addperson", forIndexPath: indexPath) as VoteAddPersonCell
        cell.backgroundColor = UIColor.yellowColor()
        cell.image.image = UIImage(named: "add")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == collectioncellCount - 1 {
            collectioncellCount++
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as VoteAddPersonCell
            collectionView.reloadData()
            tableView.reloadData()
            cell.image.image = UIImage(named: "add")
            self.performSegueWithIdentifier("contact", sender: true)
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(70, 70)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func btn(btn:UIButton) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        let textView = cell?.contentView.viewWithTag(102) as UITextView
        let label = cell?.contentView.viewWithTag(103) as  UILabel
        label.hidden = true
        textView.text = btn.currentTitle
        voteFeedDictionary.setObject(textView.text, forKey: "voteTitle")
        var i = btn.tag - 1
        optionTagArray = titleTagArray.objectAtIndex(i)["option"] as NSMutableArray
        tableView.reloadData()
    }
    
    func btnAnswer(btn:UIButton) {
        if edittextfield == false {
            let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: optionCellRowCount-1, inSection: 1)) as UITableViewCell?
            let lastTextField = lastCell?.contentView.viewWithTag(102) as UITextField
            lastTextField.text = optionTagArray.objectAtIndex(btn.tag - 10000) as NSString
            
            if optionCellRowCount < 5 {
                optionCellRowCount++
            }
            
            tableView.reloadData()
        }else {
            taptextfield.text = taptextfield.text.stringByAppendingString(optionTagArray.objectAtIndex(btn.tag - 10000) as NSString)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
}
