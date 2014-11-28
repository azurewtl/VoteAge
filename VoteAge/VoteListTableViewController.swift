//
//  MasterViewController.swift
//  VoteAge
//
//  Created by azure on 14/11/6.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData

class VoteListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, VoteDetailDelegate{

    var sendNotificationCenter = NSNotificationCenter.defaultCenter()
    var managedObjectContext: NSManagedObjectContext? = nil
    var voteArray = NSMutableArray()
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func noti(noti:NSNotification) {
        var receiveDiction = NSMutableDictionary()
        receiveDiction.setObject("12345678", forKey: "voteID")
        receiveDiction.setObject("caiyang", forKey: "voteAuthorName")
        receiveDiction.setObject("373789", forKey: "voteAuthorID")
        receiveDiction.setObject(0, forKey: "hasVoted")
        receiveDiction.setObject("http://img3.douban.com/view/movie_poster_cover/lpst/public/p2204980911.jpg", forKey: "voteImage")
        receiveDiction.setObject((noti.userInfo! as NSDictionary)["options"]!, forKey: "options")
        receiveDiction.setObject((noti.userInfo! as NSDictionary)["voteTitle"]!, forKey: "voteTitle")
        voteArray.addObject(receiveDiction)
        
        tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        activityIndicator.frame = CGRectMake(130, 200, 50, 50)
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.masksToBounds = true
        activityIndicator.layer.cornerRadius = 5
        self.view.addSubview(activityIndicator)
        var ceshi:Int = 0
        if(ceshi == 1){
            var str = "http://api.douban.com/v2/movie/coming?apikey=0df993c66c0c636e29ecbb5344252a4a&client=e:iPhone4,1|y:iPhoneOS_6.1|s:mobile|f:doubanmovie_2|v:3.3.1|m:PP_market|udid:aa1b815b8a4d1e961347304e74b9f9593d95e1c5&alt=json&version=2&app_name=doubanmovie&start=1"
            let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let group = dispatch_group_create()
            dispatch_group_async(group, queue, {
                self.activityIndicator.startAnimating()
            })
            dispatch_group_notify(group, queue, {
                AFnetworkingJS .netWorkWithURL(str, resultBlock: { (var result:AnyObject?) -> Void in
                    var str = NSString()
                   
                    self.voteArray = result?.objectForKey("entries") as NSMutableArray
                    self.activityIndicator.stopAnimating()
                })
            })
        }else{
            
            var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
            var data1 = NSData(contentsOfFile: path1!)
            
            var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
            voteArray = votedic.objectForKey("hotlist") as NSMutableArray

            
        }

        sendNotificationCenter.addObserver(self, selector: "noti:", name: "sendVote", object: nil)
    
    }
    // MARK: - protocol

    func setVoted(status: Int) {
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            var vote = voteArray[indexPath.row] as NSMutableDictionary
             vote["hasVoted"] = 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showVoteDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let vote = voteArray[indexPath.row] as NSMutableDictionary
                (segue.destinationViewController as VoteDetailTableViewController).voteDetail = vote
                (segue.destinationViewController as VoteDetailTableViewController).delegate = self
            }
        }
        
        if segue.identifier == "showAuthorDetail" {
            let senderButton = sender as UIButton
            let cell = senderButton.superview?.superview as VoteTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let voteFeed = voteArray[indexPath!.row] as NSDictionary
            (segue.destinationViewController as UserDetailTableViewController).voteFeed = voteFeed
            (segue.destinationViewController as UserDetailTableViewController).buttonTitle = "关注"
        }
        
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("voteCell", forIndexPath: indexPath) as VoteTableViewCell
        let voteItem = self.voteArray.objectAtIndex(indexPath.row) as NSDictionary
        
        cell.voteTitle.text = voteItem["voteTitle"] as NSString
        cell.voteAuthor.setTitle(voteItem["voteAuthorName"] as NSString, forState: UIControlState.Normal)
        cell.authorID = voteItem["voteAuthorID"] as NSString
        var imageUrl = NSURL(string: voteItem["voteImage"] as NSString)
       
        cell.voteImage.sd_setImageWithURL(imageUrl)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var deleteItem = NSArray(objects: indexPath)
            self.voteArray.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths(deleteItem, withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }


    //    func configureCell(cell: VoteTableViewCell, atIndexPath indexPath: NSIndexPath) {
    //        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
    //        cell.voteTitle.text = object.valueForKey("voteTitle") as? String
    //        cell.voteAuthor.setTitle(object.valueForKey("voteAuthor") as? String, forState: UIControlState.Normal)
    //        var imageUrl = NSURL(string: object.valueForKey("voteImage") as NSString)
    //        cell.voteImage.sd_setImageWithURL(imageUrl)
    //    }
    
    // MARK: - Fetched results controller
    
    //    var fetchedResultsController: NSFetchedResultsController {
    //        if _fetchedResultsController != nil {
    //            return _fetchedResultsController!
    //        }
    //
    //        let fetchRequest = NSFetchRequest()
    //        // Edit the entity name as appropriate.
    //        let entity = NSEntityDescription.entityForName("Votes", inManagedObjectContext: self.managedObjectContext!)
    //        fetchRequest.entity = entity
    //
    //        // Set the batch size to a suitable number.
    //        fetchRequest.fetchBatchSize = 20
    //
    //        // Edit the sort key as appropriate.
    //        let sortDescriptor = NSSortDescriptor(key: "voteAuthor", ascending: false)
    //        let sortDescriptors = [sortDescriptor]
    //
    //        fetchRequest.sortDescriptors = [sortDescriptor]
    //
    //        // Edit the section name key path and cache name if appropriate.
    //        // nil for section name key path means "no sections".
    //        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    //        aFetchedResultsController.delegate = self
    //        _fetchedResultsController = aFetchedResultsController
    //
    //    	var error: NSError? = nil
    //    	if !_fetchedResultsController!.performFetch(&error) {
    //    	     // Replace this implementation with code to handle the error appropriately.
    //    	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //             //println("Unresolved error \(error), \(error.userInfo)")
    //    	     abort()
    //    	}
    //
    //        return _fetchedResultsController!
    //    }
    //    var _fetchedResultsController: NSFetchedResultsController? = nil
    //
    //    func controllerWillChangeContent(controller: NSFetchedResultsController) {
    //        self.tableView.beginUpdates()
    //    }
    //
    //    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    //        switch type {
    //            case .Insert:
    //                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    //            case .Delete:
    //                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
    //            default:
    //                return
    //        }
    //    }
    //
    //    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    //        switch type {
    //            case .Insert:
    //                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    //            case .Delete:
    //                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    //            case .Update:
    //                var cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath!)! as VoteTableViewCell
    //                self.configureCell(cellToUpdate, atIndexPath: indexPath!)
    //            case .Move:
    //                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
    //                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
    //            default:
    //                return
    //        }
    //    }
    //
    //    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    //        self.tableView.endUpdates()
    //    }
    
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }
    */
    
}

