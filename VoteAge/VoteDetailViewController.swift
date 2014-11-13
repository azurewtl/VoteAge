//
//  DetailViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class VoteDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var voteImage: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var optionTableView: UITableView!

    var menTotal = CGFloat()
    var womenTotal = CGFloat()
    var voteItem = NSMutableDictionary()
    var optionArray = NSMutableArray()
    
    let animationDuration = 0.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - configureView
    
    var voteDetail: AnyObject? {
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
                    menTotal += option["menCount"] as CGFloat
                    womenTotal += option["womenCount"] as CGFloat
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
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as OptionTableViewCell
//        var barFrame = cell.optionBackground.frame
//        barFrame.size.width += 30
//        UIView.animateWithDuration(animationDuration, animations: {cell.optionBackground.frame = barFrame})
//        cell.optionImage.hidden = true
//        cell.optionBackground.frame = CGRect(x: 0, y: 0, width: 100, height: 54)
//        cell.optionTitle.frame = CGRect(x: 0, y: 0, width: 100, height: 54)
//    }
    
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
                    percentage = percentage / menTotal
                    let newWidth: CGFloat = percentage * (self.view.frame.width - 54)
                    var barFrame = CGRect(x: 54, y: 0, width: newWidth, height: 54)
                
                    UIView.animateWithDuration(animationDuration, animations: {cell!.optionBackground.frame = barFrame})
                    
                    
                }
            }
            
            
        case 1: // everyone
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    barFrame = cell!.optionBackground.frame
//                    barFrame.size.width += 10
                    var percentage = optionArray[row]["menCount"] as CGFloat
                    var persontage1 = optionArray[row]["womenCount"] as CGFloat
                    percentage = percentage + persontage1
                    percentage = percentage / (menTotal + womenTotal)
                    let newWidth: CGFloat = percentage * (self.view.frame.width - 54)
                    var barFrame = CGRect(x: 54, y: 0, width: newWidth, height: 54)
                    UIView.animateWithDuration(animationDuration, animations: {cell!.optionBackground.frame = barFrame})
                }
            }
            
        case 2: // women only
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                  var backTab = CGRectMake(54, 0, self.view.frame.width - 54, 54)
                    barFrame = cell!.optionBackground.frame
                    var percentage = optionArray[row]["womenCount"] as CGFloat
                    percentage = percentage / womenTotal
                    let newWidth: CGFloat = percentage * (self.view.frame.width - 54)
                    var barFrame = CGRect(x: 54, y: 0, width: newWidth, height: 54)
                    UIView.animateWithDuration(animationDuration, animations: {cell!.optionBackground.frame = barFrame})
                   
                }
            }
            
        default:
            println("Segment Control Error")
        }
        
        
    }
}

