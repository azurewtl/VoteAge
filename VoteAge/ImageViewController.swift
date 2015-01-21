//
//  ImageViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/28.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()
    var photoView = UIImageView()
    var imgCount = 0
    var optionArr = NSArray()
    @IBOutlet var pageLabel: UILabel!
    
    @IBAction func backTapGesture(sender: UITapGestureRecognizer) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = self.view.bounds
        self.view.backgroundColor = UIColor.blackColor()
        photoView.frame = scrollView.frame
        photoView.contentMode = UIViewContentMode.ScaleAspectFit
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.7
        scrollView.maximumZoomScale = 2
//        scrollView.contentSize = CGSizeMake(780, 960)
        scrollView.addSubview(photoView)
        self.view.addSubview(scrollView)
        scrollView.userInteractionEnabled = true
        scrollView.pagingEnabled = true
        scrollView.scrollEnabled = true
        var gesture = UITapGestureRecognizer(target: self, action: "tap")
        photoView.userInteractionEnabled = true
        photoView.addGestureRecognizer(gesture)
        if imgCount == -1{
            
        }else {
            pageLabel.text = NSString(format: "%d/%d", imgCount + 1,optionArr.count)
        for index in 0...optionArr.count - 1 {
            scrollView.contentSize = CGSizeMake(CGFloat(optionArr.count) * view.frame.width, 0)
            var imgview = UIImageView(frame: CGRectMake(CGFloat(index) * view.frame.width, 0, view.frame.width, view.frame.height))
            imgview.contentMode = UIViewContentMode.ScaleAspectFit
            var url = NSURL(string: (optionArr.objectAtIndex(index) as NSDictionary).objectForKey("image") as NSString)
        
            imgview.sd_setImageWithURL(url, placeholderImage: UIImage(named: "dummyImage"))
            scrollView.addSubview(imgview)
            scrollView.contentOffset = CGPointMake(CGFloat(imgCount) * view.frame.width, 0)
            var gest = UITapGestureRecognizer(target: self, action: "tap")
            imgview.userInteractionEnabled = true
            imgview.addGestureRecognizer(gest)
        }
        }
        
              // Do any additional setup after loading the view.
    }
     func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if imgCount == -1 {
            
        }else {
        pageLabel.text = NSString(format: "%d/%d", Int(scrollView.contentOffset.x / scrollView.frame.width) + 1,optionArr.count)
        }
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
