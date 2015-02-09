//
//  SearchViewController.swift
//  VoteAge
//
//  Created by caiyang on 15/2/9.
//  Copyright (c) 2015年 azure. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource {

    var searchArray = NSArray()
    var resultArray = NSArray()

    @IBOutlet var imageView: BlurImageView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        imageView.blurryImage(UIImage(named:"user1"), withBlurLevel: 10)
        imageView.userInteractionEnabled = true
        searchBar.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - searchBar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
       self.navigationController?.popViewControllerAnimated(false)
    }

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //contains[cd]包含
        //BEGINSWITH从哪个字母开始
        if searchText == "" {
            imageView.hidden = false
        }else {
            imageView.hidden = true
        }
        var searchResult = NSPredicate(format: "SELF contains[cd]%@", searchText)
       
        
        
        resultArray = ((searchArray.firstObject as NSDictionary).allKeys as NSArray).filteredArrayUsingPredicate(searchResult!)
        tableView.reloadData()
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        searchBar.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    // MARK: - tableview
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as UITableViewCell
        cell.textLabel.text = resultArray.objectAtIndex(indexPath.row) as NSString
        cell.detailTextLabel?.text = (searchArray.firstObject as NSDictionary).objectForKey(resultArray.objectAtIndex(indexPath.row) as NSString) as NSString
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "search" {
            let indexpath = tableView.indexPathForSelectedRow()
            let cell = tableView.cellForRowAtIndexPath(indexpath!) as UITableViewCell?
            (segue.destinationViewController as UserDetailTableViewController).contactId = cell!.detailTextLabel!.text!
        }
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
