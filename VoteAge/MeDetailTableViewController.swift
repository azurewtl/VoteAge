//
//  MeDetailTableViewController.swift
//  VoteAge
//
//  Created by Apple on 14/11/20.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
protocol sendbackInforDelegate {
    func sendbackInfo(str:NSString, img:UIImage)
}
class MeDetailTableViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate, UITextFieldDelegate {
    var tokenDefult = NSUserDefaults.standardUserDefaults()//accessToken 单例
    var delegate = sendbackInforDelegate?()
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNickName: UITextField!
    @IBOutlet weak var genderSeg: UISegmentedControl!
    @IBOutlet weak var userDescription: UITextView!
    
    @IBAction func genderSegment(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("男")
        }
        if sender.selectedSegmentIndex == 1 {
            print("女")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var str = tokenDefult.objectForKey("placeholderImage") as NSString
        var data = NSData(base64EncodedString: str, options: nil)
        var placeimg = UIImage(data: data!)
        var url = NSURL(string: tokenDefult.objectForKey("image") as NSString)
        userImage.sd_setImageWithURL(url, placeholderImage: placeimg)
        userNickName.text = tokenDefult.objectForKey("name") as? NSString
        userDescription.text = tokenDefult.objectForKey("description") as? NSString
        userNickName.delegate = self
        self.tabBarController?.tabBar.hidden = true
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        userDescription.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        if genderSeg.selectedSegmentIndex == 0 {
//            print("男")
//        }else if genderSeg.selectedSegmentIndex == 1 {
//            print("女")
//        }
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        let phonetextfield = cell1?.contentView.viewWithTag(101) as UITextField
        phonetextfield.delegate = self
        phonetextfield.text = NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString
        let imageView = cell?.contentView.viewWithTag(101) as UIImageView
        var imageGesture = UITapGestureRecognizer(target: self, action: "tapGesture")
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(imageGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Edit profile
    
    func tapGesture() {
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
    
    @IBAction func saveButton(sender: UIButton) {
        var img = userImage.image
        var data = UIImageJPEGRepresentation(img, 0.7)
        var encodeStr = data.base64EncodedStringWithOptions(nil)
        var dic1 = ["gender":genderSeg.selectedSegmentIndex + 1 ,"name":userNickName.text, "image":encodeStr,"description":userDescription.text,"accessToken":tokenDefult.valueForKey("accessToken") as NSString] as NSDictionary
        AFnetworkingJS.uploadJson(dic1, url: "http://73562.vhost33.cloudvhost.net/VoteAge/appUser/updateUser") { (result) -> Void in
            print(result)
            print(result.valueForKey("message"))
            if result.valueForKey("status") as Int == 1 {
            self.tokenDefult.setValue(self.userDescription.text, forKey: "description")
            self.tokenDefult.setValue(self.userNickName.text, forKey: "name")
            self.tokenDefult.setValue(self.genderSeg.selectedSegmentIndex + 1, forKey: "gender")
            self.tokenDefult.setValue(encodeStr, forKey: "image")
            self.navigationController?.popViewControllerAnimated(true)
            self.delegate?.sendbackInfo(self.userNickName.text, img: self.userImage.image!)
            }else {
                print("error")
            }
        }

       
    }
    
    // MARK: - Table view data source
    func textViewDidChange(textView: UITextView) {
        var str = NSMutableString(string: textView.text)
        if(str.length <= 30){
            textView.text = str
        }else{
            str.deleteCharactersInRange(NSMakeRange(30, str.length - 30))
            textView.text = str
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            tableView.contentOffset.y = -64
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 0
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker .dismissViewControllerAnimated(false, completion: { () -> Void in
        })
     
            self.userImage.image = image

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        userNickName.resignFirstResponder()
        userDescription.resignFirstResponder()
    }
}
