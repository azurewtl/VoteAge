//
//  NewVoteTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/19.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class NewVoteTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var rowCount = 1
    var tapYN = 0
    override func viewDidLoad() {
        super.viewDidLoad()
                       // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as UITableViewCell?
        var imageAskView = cell?.contentView.viewWithTag(101) as UIImageView
        var gesTure = UITapGestureRecognizer(target: self, action: "tap")
        imageAskView.userInteractionEnabled = true
        imageAskView.addGestureRecognizer(gesTure)
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as UITableViewCell?
        
        var imageAnswerView = cell1?.contentView.viewWithTag(101) as UIImageView
        var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap1")
        imageAnswerView.userInteractionEnabled = true
        imageAnswerView.addGestureRecognizer(gesTure1)

    }
    func tap() {
        tapYN = 1
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)
    }
    func tap1() {
        tapYN = 2
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
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
            var resizeImg = ImageUtil.imageFitView(image, fitforSize: CGSizeMake(83, 83))
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch self.tapYN {
                case 1:
                imageAskView.image = resizeImg
                case 2:
                imageAnswerView.image = resizeImg
                case 3:
                let cell2 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
                    var imag1 = cell2?.contentView.viewWithTag(101) as UIImageView
                    imag1.image = resizeImg
                case 4:
                let cell2 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:2, inSection: 1))
                    var imag1 = cell2?.contentView.viewWithTag(101) as UIImageView
                    imag1.image = resizeImg
                case 5:
                    let cell2 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:3, inSection: 1))
                    var imag1 = cell2?.contentView.viewWithTag(101) as UIImageView
                    imag1.image = resizeImg
                case 6:
                    let cell2 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:4, inSection: 1))
                    var imag1 = cell2?.contentView.viewWithTag(101) as UIImageView
                    imag1.image = resizeImg
                case 7:
                    let cell2 = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow:5, inSection: 1))
                    var imag1 = cell2?.contentView.viewWithTag(101) as UIImageView
                    imag1.image = resizeImg
                default:
                return
                }
            
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
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let lastCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: rowCount-1, inSection: 1)) as UITableViewCell?
        let lastTextField = lastCell?.contentView.viewWithTag(102) as UITextField
        if(lastTextField.text != ""){
            if rowCount < 5 {
                rowCount++
            }
        }
        tableView.reloadData()
        switch rowCount {
        case 2:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap2")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 3:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap3")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 4:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap4")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 5:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap5")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        case 6:
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 1))
            var imageAnswerView = cell?.contentView.viewWithTag(101) as UIImageView
            var  gesTure1 = UITapGestureRecognizer(target: self, action: "tap6")
            imageAnswerView.userInteractionEnabled = true
            imageAnswerView.addGestureRecognizer(gesTure1)
        default:
            return
        }
        
    }
    func tap2() {
        tapYN = 3
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)

    }
    func tap3() {
        tapYN = 4
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)
        
    }
    func tap4() {
        tapYN = 5
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)
        
    }
    func tap5() {
        tapYN = 6
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)
        
    }
    func tap6() {
        tapYN = 7
        var photoSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照","相册")
        photoSheet.showInView(self.view)
        
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
    
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
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
