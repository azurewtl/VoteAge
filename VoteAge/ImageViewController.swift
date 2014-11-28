//
//  ImageViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/28.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBAction func backTapGesture(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    var scrollView = UIScrollView()
    var photoView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = self.view.bounds
        self.view.backgroundColor = UIColor.blackColor()
        photoView.frame = scrollView.frame
        photoView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 3.0
        scrollView.contentSize = CGSizeMake(780, 960)
        scrollView.addSubview(photoView)
        self.view.addSubview(scrollView)
        scrollView.userInteractionEnabled = true
        var gesture = UITapGestureRecognizer(target: self, action: "tap")
        photoView.userInteractionEnabled = true
        photoView.addGestureRecognizer(gesture)
              // Do any additional setup after loading the view.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoView
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
