//
//  LightTableViewController.swift
//  Homee
//
//  Created by Realank-Mac on 15/4/5.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

class SwitchTableViewController: UITableViewController, SwitchChangedDelegate, SwitchDataHasUpdateDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    var navigationBarDefaultName : String?
    
    let switchData = SwitchData()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        switchData.switchDataHasUpdateDelegater = self
        navigationBarDefaultName = navigationBar.title
        self.refreshControl?.beginRefreshing()
        refreshdata(self.refreshControl)
        
        
    }
    
    // MARK: - code to refresh the data

    @IBAction func refreshdata(sender: UIRefreshControl?) {
        println("screen was pulled down to refresh")
        
        navigationBar.title = "重新加载中..."
        sender?.endRefreshing()
        switchData.reloadData()
        refreshTable()
    }
    
    func refreshTable(){
        println("freshTable was called")
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return switchData.sectionsForTable
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println("tableView was called")
        return switchData.numberOfRowsInSection()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : SwitchTableViewCell
        if SwitchData.switches[indexPath.row].type == 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell3Segment", forIndexPath: indexPath) as! SwitchTableViewCell
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchTableViewCell
        }
        
        // Configure the cell...
        cell.switchChangedDelegater = self
        cell.setStatus("\(SwitchData.switches[indexPath.row].name)",
            wait: SwitchData.switches[indexPath.row].waiting,
            statNum: SwitchData.switches[indexPath.row].value)

        return cell
    }
    
    func switchChangedByUser(switchName: String, withValue value: Int){
        println("segment changed by user: \(switchName) : \(value)")
        switchData.setSpecificData(switchName, withValue: value)
    }
    
    
    func switchDataHasUpdate(){
        navigationBar.title = navigationBarDefaultName ?? "Homee"
        refreshTable()
//        if let userDefault:NSUserDefaults = NSUserDefaults(suiteName: "group.AWdataShare") {
//            //let value = userDefault.integerForKey("shareInt")
//            userDefault.setInteger(SwitchData.switches.count+num, forKey: "lightNum")
//        }
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
