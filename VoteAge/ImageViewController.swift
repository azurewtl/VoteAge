//
//  ImageViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/28.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBAction func backTapGesture(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    var photoView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
     self.view.backgroundColor = UIColor.whiteColor()
        photoView.frame = self.view.bounds
        self.view.addSubview(photoView)
        var gesture = UITapGestureRecognizer(target: self, action: "tap")
        photoView.userInteractionEnabled = true
        photoView.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    func tap() {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
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
