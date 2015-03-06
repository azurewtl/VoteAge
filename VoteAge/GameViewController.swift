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
    var score1 = 100
    var energy = 10
    var addscore = true
    
    @IBAction func cancelOnclick(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    @IBOutlet var myEnergylabel: UILabel!
    @IBOutlet var headtoolImage: UIImageView!
    
    @IBOutlet var headrightImage: UIImageView!
    
    @IBOutlet var score1Label: UILabel!
    @IBOutlet var scorelabel: UILabel!
    @IBOutlet var headerImage: UIImageView!
    
    @IBOutlet var header1Image: UIImageView!
    @IBAction func headrTap(sender: UITapGestureRecognizer) {
        headrightImage.hidden = true
        if energy == 0 {
         var alert = UIAlertView(title: "提示", message: "体力不够啦", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }else {
        sender.enabled = false
        self.headtoolImage.hidden = true
        self.handImageView.animationImages = array
        self.handImageView.animationDuration = 0.4
        self.handImageView.startAnimating()
        var point = toolImage.center
        UIView.animateWithDuration(0.4, animations: { () -> Void in
      
            self.toolImage.center = self.headerImage.center
            }) { (finished) -> Void in
                self.energy--
                self.myEnergylabel.text = NSString(format: "体力 %d", self.energy)
                if self.addscore == false {
                self.score--
                }else {
                self.score++
                }
                if self.toolImage.center == self.headerImage.center {
                    if self.toolImage.image == self.flower.image {
                        self.headtoolImage.image = self.toolImage.image
                    }else {
                        self.headtoolImage.image = UIImage(named: "brokenegg")
                    }
                    self.headtoolImage.hidden = false
                    
                }
                self.scorelabel.text = self.score.description
                self.toolImage.center = point
                sender.enabled = true
                self.handImageView.stopAnimating()
        }
        }
        
    }
    
    @IBAction func header1Tap(sender: UITapGestureRecognizer) {
        headtoolImage.hidden = true
        if energy == 0 {
            var alert = UIAlertView(title: "提示", message: "体力不够啦", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }else {
        sender.enabled = false
        self.headrightImage.hidden = true
        self.handImageView.animationImages = array
        self.handImageView.animationDuration = 0.4
        self.handImageView.startAnimating()
        var point = toolImage.center
        UIView.animateWithDuration(0.4, animations: { () -> Void in
      
            self.toolImage.center = self.header1Image.center
            }) { (finished) -> Void in
                self.energy--
                self.myEnergylabel.text = NSString(format: "体力 %d", self.energy)
                if self.addscore == false {
                    self.score1--
                }else {
                    self.score1++
                }
                if self.toolImage.image == self.flower.image {
                    self.headrightImage.image = self.toolImage.image
                }else {
                    self.headrightImage.image = UIImage(named: "brokenegg")
                }
                    self.headrightImage.hidden = false
                
                self.score1Label.text = self.score1.description
                self.toolImage.center = point
                sender.enabled = true
                self.handImageView.stopAnimating()
        }
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
    
        headtoolImage.hidden = true
        headrightImage.hidden = true
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
