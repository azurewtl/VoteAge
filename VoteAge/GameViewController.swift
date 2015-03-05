//
//  GameViewController.swift
//  VoteAge
//
//  Created by caiyang on 15/3/5.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var score = 100
    var addscore = true
    
    
    @IBAction func closeOnclick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBOutlet var scorelabel: UILabel!
    @IBOutlet var headerImage: UIImageView!
    
    @IBAction func headrTap(sender: UITapGestureRecognizer) {
        sender.enabled = false
        self.handImageView.animationImages = array
        self.handImageView.animationDuration = 0.4
        self.handImageView.startAnimating()
        var point = toolImage.center
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.toolImage.center = self.headerImage.center
            }) { (finished) -> Void in
                if self.addscore == false {
                self.score--
                }else {
                self.score++
                }
                self.scorelabel.text = self.score.description
                self.toolImage.center = point
                sender.enabled = true
                self.handImageView.stopAnimating()
        }
        
    }
    @IBOutlet var egg: UIImageView!
    @IBOutlet var flower: UIImageView!
    @IBOutlet var toolImage: UIImageView!
    @IBOutlet var handImageView: UIImageView!
    
  
    @IBAction func agreeTap(sender: UITapGestureRecognizer) {
        toolImage.image = flower.image
        addscore = true
    }
    
    @IBAction func disagreeTap(sender: UITapGestureRecognizer) {
        toolImage.image = egg.image
        addscore = false
    }
    var array = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0...2 {
            var name = NSString(format: "%d", index)
            var image = UIImage(named: name)
            array.addObject(image!)
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
