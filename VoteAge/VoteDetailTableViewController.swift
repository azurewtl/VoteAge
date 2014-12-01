//
//  DetailViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit

protocol VoteDetailDelegate{
    func setVoted(status:Int)
}

class VoteDetailTableViewController: UITableViewController, ImagesendDelegate, UIActionSheetDelegate{
 
    @IBOutlet weak var voteImage: UIImageView!
    @IBOutlet weak var voteTitle: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var waiveButton: UIButton!
    @IBOutlet weak var voteSegment: UISegmentedControl!
    var delegate = VoteDetailDelegate?()
    var menCount = CGFloat()
    var womenCount = CGFloat()
    var optionArray = NSMutableArray()
    var time = NSTimeInterval()
    var timer = NSTimer()
    let animationDuration = 0.15
    
    @IBAction func optionitem(sender: UIBarButtonItem) {
        
        var selectSheet = UIActionSheet(title: "提示", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "收藏", "定位", "分享")
        selectSheet.showInView(self.view)
    }
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 3 {
            var publishContent = ShareSDK.content("adasd", defaultContent: "VoteAge", image: nil, title: "VoteAge", url: "http://www.sharesdk.cn", description: "这是一条测试信息", mediaType: SSPublishContentMediaTypeNews)
            
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
      
    
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        if(voteDetail!["hasVoted"] as Int == 0){
            tableView.allowsSelection = false
            waiveButton.userInteractionEnabled = false
            voteSegment.userInteractionEnabled = false
            timeCount()
        }else{
            self.voteTotalperson()
            waiveButton.hidden = true
        }
        
    }
    


    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - waiveButton
    
    @IBAction func waiveButton(sender: UIButton) {
        sender.hidden = true
        self.voteTotalperson()
     self.delegate?.setVoted(1)
    }
    
    func timeCount() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timeFire", userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func timeFire(){
        time++
        waiveButton .setTitle((3 - time).description + "秒后可以投票", forState: UIControlState.Normal)
        if(time > 2){
            time = 0
            waiveButton.userInteractionEnabled = true
            waiveButton .setTitle("放弃投票,查看结果", forState: UIControlState.Normal)
            self.tableView.allowsSelection = true
            voteSegment.userInteractionEnabled = true
            timer.invalidate()
        }
        
    }
    
    // MARK: - totalVoted
    func voteTotalperson() {
        let rowCount = tableView.numberOfRowsInSection(0)
        var cell: OptionTableViewCell?
        tableView.allowsSelection = false
        // add count to men or women
        //
        //
        for row in 0...rowCount-1{
            cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
            if ((cell) != nil) {
                var percentage = optionArray[row]["menCount"] as CGFloat
                percentage += optionArray[row]["womenCount"] as CGFloat
                percentage = percentage / (menCount + womenCount)
                cell?.optionProgress.setProgress(Float(percentage), animated: true)
                let perInt = Int(percentage * 100)
                cell?.optionDetail.text = perInt.description + "%"
                
            }
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    func setSelect(number: Int) {
        var imagevc = ImageViewController()
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: number, inSection: 0)) as OptionTableViewCell?
        imagevc.photoView.image = cell?.optionImage.image
        imagevc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        presentViewController(imagevc, animated: true) { () -> Void in
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "titleImage" {
           
            (segue.destinationViewController as ImageViewController).photoView.image = self.voteImage.image
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as OptionTableViewCell
        var dicAppear = self.optionArray.objectAtIndex(indexPath.row) as NSDictionary
        cell.optionTitle.text = dicAppear.objectForKey("title") as NSString
       cell.delegate = self
        cell.imagenumber = indexPath.row
    
        return cell
    }
    
    
    // MARK: - Table VIew Selection
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.setVoted(1)
        self.voteTotalperson()
        waiveButton.hidden = true
        voteSegment.selectedSegmentIndex = 1;
    }
    
    // MARK: - Segment Control
    
    @IBAction func voteSegment(sender: UISegmentedControl) {
        
        let rowCount = tableView.numberOfRowsInSection(0)
        
        switch(sender.selectedSegmentIndex) {
        case 0: // men only
            var cell: OptionTableViewCell?
            for row in 0...rowCount-1{
                cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
                if ((cell) != nil) {
                    
                    var percentage = optionArray[row]["menCount"] as CGFloat
                    percentage = percentage / menCount
                    cell?.optionProgress.setProgress(Float(percentage), animated: true)
                    let perInt = Int(percentage * 100)
                    cell?.optionDetail.text = perInt.description + "%"
                }
            }
            
            
        case 1: // everyone
         self.voteTotalperson()
            
        case 2: // women only
            var cell: OptionTableViewCell?
            for row in 0...rowCount-1{
                cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as OptionTableViewCell?
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

