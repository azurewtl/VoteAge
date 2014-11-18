//
//  MyConcernViewController.swift
//  VoteAge
//
//  Created by caiyang on 14/11/17.
//  Copyright (c) 2014年 azure. All rights reserved.
//

import UIKit
import CoreData
class MyConcernViewController: UITableViewController {
    var managedObjectContext = NSManagedObjectContext()
    var realSectionArray = NSMutableArray()
    var totalArray = NSMutableArray()
    var friendArray = NSMutableArray()
//    var albumArray = NSMutableArray()
//    var formatArray = NSMutableArray()
    @IBAction func finishSelect(sender: UIButton) {
        
    }
    
    func saveToCoreData(index:Int) {
        
        
        

            var vote = NSEntityDescription.insertNewObjectForEntityForName("Votes", inManagedObjectContext: self.managedObjectContext) as NSManagedObject
            
            var strrUsername = friendArray.objectAtIndex(index)["userName"] as NSString
            vote.setValue(friendArray.objectAtIndex(index)["userName"] as NSString, forKey: "userName")
            vote.setValue(friendArray.objectAtIndex(index)["userID"] as NSString, forKey: "userID")
            vote.setValue(friendArray.objectAtIndex(index)["userImage"] as NSString, forKey: "userImage")
            vote.setValue(friendArray.objectAtIndex(index)["gender"] as NSString, forKey: "gender")
            vote.setValue(friendArray.objectAtIndex(index)["city"] as NSString, forKey: "city")
            vote.setValue(friendArray.objectAtIndex(index)["discription"] as NSString, forKey: "descrip")
            
            if(strrUsername.characterAtIndex(0) > 64 && strrUsername.characterAtIndex(0) < 123){
                //                self.albumArray.addObject(strr)
                var ss = Character(UnicodeScalar(strrUsername.characterAtIndex(0).hashValue))
                //                self.formatArray.addObject(String(ss))
                vote.setValue(String(ss), forKey: "firstAlbum")
                //                vote.firstAlbum = String(ss)
            }else{
                
                var char = Int(pinyinFirstLetter(strrUsername.characterAtIndex(0)))
                let c =  Character(UnicodeScalar(char))
                //                self.albumArray.addObject(strr)
                //                self.formatArray.addObject(String(c))
                //                vote.firstAlbum = String(c)
                vote.setValue(String(c), forKey: "firstAlbum")
            }
            

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Core Data
        let app = UIApplication.sharedApplication().delegate as AppDelegate
        managedObjectContext = app.managedObjectContext!
        
        // For Test
        var path1 = NSBundle.mainBundle().pathForResource("testData1", ofType:"json")
        var data1 = NSData(contentsOfFile: path1!)

        var votedic = NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.MutableContainers, error:nil) as NSDictionary
        //
        friendArray = votedic["friendlist"] as NSMutableArray
        for index in 0...friendArray.count - 1 {
            //if exited
                //update
            //else
                saveToCoreData(index)
        }
        managedObjectContext.save(nil)
        
        
        var fetchPerson = NSFetchRequest(entityName: "Votes") as NSFetchRequest
        var sort =  NSSortDescriptor(key: "userName", ascending: true) as NSSortDescriptor
        fetchPerson.sortDescriptors = [sort]
        var ar = managedObjectContext.executeFetchRequest(fetchPerson, error: nil)
        totalArray.addObject(ar!)
        
        
        // Read From CoreData
        var ar1 = (totalArray[0].valueForKey("firstAlbum")) as NSArray
        var ar2 = (totalArray[0].valueForKey("userName")) as NSArray
        var ar3 = (totalArray[0].valueForKey("userImage")) as NSArray
        var arrayA = NSMutableArray()
        var arrayB = NSMutableArray()
        var arrayC = NSMutableArray()
        var arrayD = NSMutableArray()
        var arrayE = NSMutableArray()
        var arrayF = NSMutableArray()
        var arrayG = NSMutableArray()
        var arrayH = NSMutableArray()
        var arrayI = NSMutableArray()
        var arrayJ = NSMutableArray()
        var arrayK = NSMutableArray()
        var arrayL = NSMutableArray()
        var arrayM = NSMutableArray()
        var arrayN = NSMutableArray()
        var arrayO = NSMutableArray()
        var arrayP = NSMutableArray()
        var arrayQ = NSMutableArray()
        var arrayR = NSMutableArray()
        var arrayS = NSMutableArray()
        var arrayT = NSMutableArray()
        var arrayU = NSMutableArray()
        var arrayV = NSMutableArray()
        var arrayW = NSMutableArray()
        var arrayX = NSMutableArray()
        var arrayY = NSMutableArray()
        var arrayZ = NSMutableArray()
        for var i = 0; i < ar1.count; i++ {
            if(ar1[i] as NSString == "a" || ar1[i] as NSString == "A"){
                arrayA.addObject(ar1[i])
                arrayA.addObject(ar2[i])
                arrayA.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "b" || ar1[i] as NSString == "B"){
              
                arrayB.addObject(ar1[i])
                arrayB.addObject(ar2[i])
                arrayB.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "c" || ar1[i] as NSString == "C"){
               
                arrayC.addObject(ar1[i])
                arrayC.addObject(ar2[i])
                arrayC.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "d" || ar1[i] as NSString == "D"){
                
                arrayD.addObject(ar1[i])
                arrayD.addObject(ar2[i])
                arrayD.addObject(ar3[i])
            
            }else
            if(ar1[i] as NSString == "e" || ar1[i] as NSString == "E"){
         
                arrayE.addObject(ar1[i])
                arrayE.addObject(ar2[i])
                arrayE.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "f" || ar1[i] as NSString == "F"){
                
                arrayF.addObject(ar1[i])
                arrayF.addObject(ar2[i])
                arrayF.addObject(ar3[i])
              
            }else
            if(ar1[i] as NSString == "g" || ar1[i] as NSString == "G"){
               
                arrayG.addObject(ar1[i])
                arrayG.addObject(ar2[i])
                arrayG.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "h" || ar1[i] as NSString == "H"){
               
                arrayH.addObject(ar1[i])
                arrayH.addObject(ar2[i])
                arrayH.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "i" || ar1[i] as NSString == "I"){
              
                arrayI.addObject(ar1[i])
                arrayI.addObject(ar2[i])
                arrayI.addObject(ar3[i])
              
            }else
            if(ar1[i] as NSString == "j" || ar1[i] as NSString == "J"){
               
                arrayJ.addObject(ar1[i])
                arrayJ.addObject(ar2[i])
                arrayJ.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "k" || ar1[i] as NSString == "K"){
                
                arrayK.addObject(ar1[i])
                arrayK.addObject(ar2[i])
                arrayK.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "l" || ar1[i] as NSString == "L"){
               
                arrayL.addObject(ar1[i])
                arrayL.addObject(ar2[i])
                arrayL.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "m" || ar1[i] as NSString == "M"){
               
                arrayM.addObject(ar1[i])
                arrayM.addObject(ar2[i])
                arrayM.addObject(ar3[i])
             
            }else
            if(ar1[i] as NSString == "n" || ar1[i] as NSString == "N"){
                
                arrayN.addObject(ar1[i])
                arrayN.addObject(ar2[i])
                arrayN.addObject(ar3[i])
              
            }else
            if(ar1[i] as NSString == "o" || ar1[i] as NSString == "O"){
                
                arrayO.addObject(ar1[i])
                arrayO.addObject(ar2[i])
                arrayO.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "p" || ar1[i] as NSString == "P"){
               
                arrayP.addObject(ar1[i])
                arrayP.addObject(ar2[i])
                arrayP.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "q" || ar1[i] as NSString == "Q"){
               
                arrayQ.addObject(ar1[i])
                arrayQ.addObject(ar2[i])
                arrayQ.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "r" || ar1[i] as NSString == "R"){
                
                arrayR.addObject(ar1[i])
                arrayR.addObject(ar2[i])
                arrayR.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "s" || ar1[i] as NSString == "S"){
               
                arrayS.addObject(ar1[i])
                arrayS.addObject(ar2[i])
                arrayS.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "t" || ar1[i] as NSString == "T"){
               
                arrayT.addObject(ar1[i])
                arrayT.addObject(ar2[i])
                arrayT.addObject(ar3[i])
              
            }else
            if(ar1[i] as NSString == "u" || ar1[i] as NSString == "U"){
                
                arrayU.addObject(ar1[i])
                arrayU.addObject(ar2[i])
                arrayU.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "v" || ar1[i] as NSString == "V"){
               
                arrayV.addObject(ar1[i])
                arrayV.addObject(ar2[i])
                arrayV.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "w" || ar1[i] as NSString == "W"){
                
                arrayW.addObject(ar1[i])
                arrayW.addObject(ar2[i])
                arrayW.addObject(ar3[i])
                
            }else
            if(ar1[i] as NSString == "x" || ar1[i] as NSString == "X"){
                
                arrayX.addObject(ar1[i])
                arrayX.addObject(ar2[i])
                arrayX.addObject(ar3[i])
               
            }else
            if(ar1[i] as NSString == "y" || ar1[i] as NSString == "Y"){
              
                arrayY.addObject(ar1[i])
                arrayY.addObject(ar2[i])
                arrayY.addObject(ar3[i])
              
            }else if(ar1[i] as NSString == "z" || ar1[i] as NSString == "Z"){
                
                arrayZ.addObject(ar1[i])
                arrayZ.addObject(ar2[i])
                arrayZ.addObject(ar3[i])
               
            }
           
        }
        
        
        if(arrayA.count > 0){
            self.realSectionArray.addObject(arrayA)
        }
        if(arrayB.count > 0){
            self.realSectionArray.addObject(arrayB)
        }
        if(arrayC.count > 0){
            self.realSectionArray.addObject(arrayC)
        }
        if(arrayD.count > 0){
            self.realSectionArray.addObject(arrayD)
        }
        if(arrayE.count > 0){
            self.realSectionArray.addObject(arrayE)
        }
        if(arrayF.count > 0){
            self.realSectionArray.addObject(arrayF)
        }
        if(arrayG.count > 0){
            self.realSectionArray.addObject(arrayG)
        }
        if(arrayH.count > 0){
            self.realSectionArray.addObject(arrayH)
        }
        if(arrayI.count > 0){
            self.realSectionArray.addObject(arrayI)
        }
        if(arrayJ.count > 0){
            self.realSectionArray.addObject(arrayJ)
        }
        if(arrayK.count > 0){
            self.realSectionArray.addObject(arrayK)
        }
        if(arrayL.count > 0){
            self.realSectionArray.addObject(arrayL)
        }
        if(arrayM.count > 0){
            self.realSectionArray.addObject(arrayM)
        }
        if(arrayN.count > 0){
            self.realSectionArray.addObject(arrayN)
        }
        if(arrayO.count > 0){
            self.realSectionArray.addObject(arrayO)
        }
        if(arrayP.count > 0){
            self.realSectionArray.addObject(arrayP)
        }
        if(arrayQ.count > 0){
            self.realSectionArray.addObject(arrayQ)
        }
        if(arrayR.count > 0){
            self.realSectionArray.addObject(arrayR)
        }
        if(arrayS.count > 0){
            self.realSectionArray.addObject(arrayS)
        }
        if(arrayT.count > 0){
            self.realSectionArray.addObject(arrayT)
        }
        if(arrayU.count > 0){
            self.realSectionArray.addObject(arrayU)
        }
        if(arrayV.count > 0){
            self.realSectionArray.addObject(arrayV)
        }
        if(arrayW.count > 0){
            self.realSectionArray.addObject(arrayW)
        }
        if(arrayX.count > 0){
            self.realSectionArray.addObject(arrayX)
        }
        if(arrayY.count > 0){
            self.realSectionArray.addObject(arrayY)
        }
        if(arrayZ.count > 0){
            self.realSectionArray.addObject(arrayZ)
        }
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return realSectionArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        print(self.realSectionArray.objectAtIndex(section).count)
        return (self.realSectionArray.objectAtIndex(section).count) / 3
//        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        var string = self.realSectionArray[indexPath.section][indexPath.row * 3 + 1] as NSString
//
////        var char = Int(pinyinFirstLetter(string.characterAtIndex(0)))
////        let c =  Character(UnicodeScalar(char))
        cell.textLabel.text =  string
//        cell.textLabel.text = "121"
        var str = self.realSectionArray.objectAtIndex(indexPath.section)[indexPath.row * 3 + 2] as NSString
        var url = NSURL(string: str)
        cell.imageView.sd_setImageWithURL(url)
//
       
        return cell
    }
   
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return realSectionArray.objectAtIndex(section)[0].description
    }
//
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        var ArrayBack = NSMutableArray()
        for var i = 0; i < realSectionArray.count; i++ {
            var str = realSectionArray[i][0] as NSString
            ArrayBack.addObject(str)
        }
        return ArrayBack
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
