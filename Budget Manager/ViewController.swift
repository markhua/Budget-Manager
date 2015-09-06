//
//  ViewController.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/4/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var accesstoken: String!
    
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var Expense: UILabel!
    @IBOutlet weak var Saving: UILabel!
    @IBOutlet weak var goalfield: UITextField!
    @IBOutlet weak var setgoalbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AccountClient.sharedInstance().accounts.removeAll(keepCapacity: true)
        AccountClient.sharedInstance().totalexpense = 0
        AccountClient.sharedInstance().totalincome = 0
        AccountClient.sharedInstance().monthlyexpense = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        AccountClient.sharedInstance().expensebycat = [0, 0, 0, 0]
        let analyzebutton = UIBarButtonItem(title: "Analyze", style: UIBarButtonItemStyle.Plain, target: self, action: "Analyze:")
        self.navigationItem.rightBarButtonItem = analyzebutton
        
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        AccountClient.sharedInstance().getaccountlist(accesstoken, view: self.tableview)
        AccountClient.sharedInstance().getalltransactions("2014", accesstoken: self.accesstoken, label1: income, label2: Expense, label3: Saving)
        
        var goal = NSUserDefaults.standardUserDefaults().valueForKey("Goal") as? String
        dispatch_async(dispatch_get_main_queue()){
            if (goal != nil) {
                self.goalfield.text = goal
            }
        }
        
        self.tableview.reloadData()
    }
    
    @IBAction func goalsetting(sender: UIButton) {
        if goalfield.text != nil {
            dispatch_async(dispatch_get_main_queue()){
                NSUserDefaults.standardUserDefaults().setValue(self.goalfield.text, forKey: "Goal")
                self.setgoalbutton.titleLabel?.text = "Change"
                self.notificationmsg("Goal Saved!")
            }
        }
    }
    @IBAction func Analyze(sender: UIBarButtonItem) {

        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("BarChartViewController")! as! BarChartViewController
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "AccountCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        let account = AccountClient.sharedInstance().accounts[indexPath.row]
        
        dispatch_async(dispatch_get_main_queue()){
            cell.textLabel?.text = account.name!
            cell.detailTextLabel?.text = "Card Type: \(account.type!), Number: xxxxx \(account.number!), \nCurrent Balance: \(account.balance!)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountClient.sharedInstance().accounts.count
    }
    
    // Navigate to the detail view controller to make the plan after selecting the venue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        TransactionClient.sharedInstance().transactions.removeAll(keepCapacity: true)
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("TransactionViewController")! as! TransactionViewController
        detailController.selectedacct = AccountClient.sharedInstance().accounts[indexPath.row]
        detailController.accesstoken = self.accesstoken
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }

    //Display notification with message string
    func notificationmsg (msgstring: String)
    {
        dispatch_async(dispatch_get_main_queue()){
            let controller = UIAlertController(title: "Notification", message: msgstring, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

}

