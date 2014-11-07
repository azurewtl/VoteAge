//
//  DetailViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var optionImage: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var optionTabBar: UITabBar!
    @IBOutlet weak var optionTableView: UITableView!
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
            if let label = voteTitle {
                label.text = "this is title"
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as OptionTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: OptionTableViewCell, atIndexPath indexPath: NSIndexPath) {
        cell.title.text = "option1"
        
    }
    
    // MARK: - Table VIew Selection
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as OptionTableViewCell
        var barFrame = cell.backgroundLabel.frame
        barFrame.size.width += 30
        UIView.animateWithDuration(animationDuration, animations: {cell.backgroundLabel.frame = barFrame})
        
    }
    
    // MARK: - TabBar

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        let rowCount = optionTableView.numberOfRowsInSection(0)
        
        switch(item.title!) {
        case "只看男":
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    barFrame = cell!.backgroundLabel.frame
                    barFrame.size.width += 30
                    UIView.animateWithDuration(animationDuration, animations: {cell!.backgroundLabel.frame = barFrame})
                }
            }
            
            
        case "所有人":
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    barFrame = cell!.backgroundLabel.frame
                    barFrame.size.width += 10
                    UIView.animateWithDuration(animationDuration, animations: {cell!.backgroundLabel.frame = barFrame})
                }
            }
            
        case "只看女":
            var cell: OptionTableViewCell?
            var barFrame: CGRect
            for row in 0...rowCount-1{
                cell = optionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    barFrame = cell!.backgroundLabel.frame
                    barFrame.size.width -= 30
                    UIView.animateWithDuration(animationDuration, animations: {cell!.backgroundLabel.frame = barFrame})
                }
            }
            
        default:
            println("Option Tab Bar Error")
        }
        
        
    }
}

