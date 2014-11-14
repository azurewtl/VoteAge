//
//  DetailViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

protocol sendBack{
    func changevalue(status:Int)
}

class VoteDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var voteImage: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var waiveButton: UIButton!
    @IBOutlet weak var voteSegment: UISegmentedControl!
 
    var delegate:sendBack?
    var menCount = CGFloat()
    var womenCount = CGFloat()
    var optionArray = NSMutableArray()
    var time = NSTimeInterval()
    var timer = NSTimer()
    let animationDuration = 0.15
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(voteDetail!["voteStatus"] as Int == 0){
            optionTableView.allowsSelection = false
            waiveButton.userInteractionEnabled = false
            voteSegment.userInteractionEnabled = false
            timeCount()
        }else{
            waiveButton.hidden = true
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - waiveButton
    
    @IBAction func waiveButton(sender: UIButton) {
        sender.hidden = true
        waiveButton.setTitle("放弃投票", forState: UIControlState.Normal)
    }
    
    func timeCount() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeFire", userInfo: nil, repeats: true)
        
        timer.fire()
    }
    func timeFire(){
        time++
        waiveButton .setTitle((4 - time).description + "秒后开始", forState: UIControlState.Normal)
        if(time > 3){
            time = 0
            //            self.view.userInteractionEnabled = true
            
            waiveButton.userInteractionEnabled = true
            waiveButton .setTitle("放弃投票", forState: UIControlState.Normal)
            self.optionTableView.allowsSelection = true
            voteSegment.userInteractionEnabled = true
            timer.invalidate()
        }
        
    }
    
    
    // MARK: - configureView
    
    var voteDetail: NSDictionary? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail: AnyObject = self.voteDetail {
            
            if(voteTitle != nil) {
                voteTitle.text = detail.objectForKey("voteTitle") as NSString
                var str = detail["voteImage"] as NSString
                var url = NSURL(string: str)
                voteImage.sd_setImageWithURL(url)
                self.optionArray = detail.objectForKey("options") as NSMutableArray
                for option in optionArray{
                    menCount += option["menCount"] as CGFloat
                    womenCount += option["womenCount"] as CGFloat
                }
                
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as OptionTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        var dicAppear = self.optionArray.objectAtIndex(indexPath.row) as NSDictionary
        cell.optionTitle.text = dicAppear.objectForKey("title") as NSString
        
        return cell
    }
    
    func configureCell(cell: OptionTableViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.optionTitle.text = "option1"
        
    }
    
    // MARK: - Table VIew Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as OptionTableViewCell
        self.delegate?.changevalue(1)
        
        //        var barFrame = cell.optionBackground.frame
        //        barFrame.size.width += 30
        //        UIView.animateWithDuration(animationDuration, animations: {cell.optionBackground.frame = barFrame})
        //        cell.optionImage.hidden = true
        //        cell.optionBackground.frame = CGRect(x: 0, y: 0, width: 100, height: 54)
        //        cell.optionTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 54)
    }
    
    // MARK: - Segment Control
    
    @IBAction func voteSegment(sender: UISegmentedControl) {
        println()
        
        let rowCount = optionTableView.numberOfRowsInSection(0)
        
        switch(sender.selectedSegmentIndex) {
        case 0: // men only
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    
                    var percentage = optionArray[row]["menCount"] as CGFloat
                    percentage = percentage / menCount
                    cell?.optionProgress.setProgress(Float(percentage), animated: true)
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
            
        case 1: // everyone
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    var percentage = optionArray[row]["menCount"] as CGFloat
                    percentage += optionArray[row]["womenCount"] as CGFloat
                    percentage = percentage / (menCount + womenCount)
                    cell?.optionProgress.setProgress(Float(percentage), animated: true)
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
        case 2: // women only
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    var backTab = CGRectMake(54, 0, self.view.frame.width - 54, 54)
                    var percentage = optionArray[row]["womenCount"] as CGFloat
                    percentage = percentage / womenCount
                    
                    cell?.optionProgress.setProgress(Float(percentage), animated: true)
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
        default:
            println("Segment Control Error")
        }
        
        
    }
}

