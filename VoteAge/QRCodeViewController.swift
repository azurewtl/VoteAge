//
//  QRCodeViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/15.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    var line = UIImageView()
//    var imgView = BlurImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
//        imgView.blurryImage(UIImage(named: "scan"), withBlurLevel: 10)
//        imgView.frame = view.bounds
//        imgView.alpha = 0.7
//        self.view.addSubview(imgView)
        self.setupCamera()
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.hidden = false
        session.startRunning()
        line.frame = CGRectMake(50, 100, view.frame.width - 100, 3)
//        line.backgroundColor = UIColor.greenColor()
        line.image = UIImage(named:"line.png")
        self.view.addSubview(line)
        UIView.beginAnimations("id", context: nil)
        UIView.setAnimationDuration(4)
        UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
        UIView.setAnimationRepeatCount(1000)
        line.frame = CGRectMake(50, 400, view.frame.width - 100,3)
        UIView.commitAnimations()
    
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        session.stopRunning()
        line.frame = CGRectMake(50, 100, view.frame.width - 100, 3)
        line.layer.removeAllAnimations()
    }
    func setupCamera() {
        
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error: NSError?
        let input = AVCaptureDeviceInput(device: device, error: &error)
        if(error != nil){
            return
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = view.frame
        view.layer.insertSublayer(self.layer, atIndex: 0)

        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        session.startRunning()
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        var stringValue:String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        println("code is \(stringValue)")
        
        //        let alertController = UIAlertController(title: "二维码", message: "扫到的二维码内容为:\(stringValue)", preferredStyle: UIAlertControllerStyle.Alert)
        //        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
        //        self.presentViewController(alertController, animated: true, completion: nil)
        var alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "二维码"
        alertView.message = "扫到的二维码内容为:\(stringValue)"
        alertView.addButtonWithTitle("确认")
        alertView.show()
//        var url = NSURL(string: stringValue!)
//        UIApplication.sharedApplication().openURL(url!)
        
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
