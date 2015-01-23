//
//  MakeqrcViewController.swift
//  VoteAge
//
//  Created by caiyang on 15/1/23.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class MakeqrcViewController: UIViewController {
    var qrcStr = NSString()
    @IBOutlet var qrcImageView: UIImageView!
    
    @IBAction func shareOnclick(sender: UIButton) {
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var imageviewdata = UIImagePNGRepresentation(qrcImageView.image) as NSData
        var documentdirectory = paths.objectAtIndex(0) as NSString
        var picName = "qrcShow.png"
        var savepath = documentdirectory.stringByAppendingPathComponent(picName)
        imageviewdata.writeToFile(savepath, atomically: true)
        var publishContent = ShareSDK.content("VoteAge", defaultContent: "VoteAge", image: ShareSDK.imageWithPath(savepath), title: "VoteAge", url: qrcStr, description: "这是一条测试信息", mediaType: SSPublishContentMediaTypeNews)
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        if qrcStr == "" {
            print("error")
        }else {
        qrcImageView.image = QRCodeGenerator.qrImageForString(qrcStr, imageSize: qrcImageView.bounds.size.width)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
