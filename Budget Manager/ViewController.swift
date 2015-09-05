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
    
    override func viewDidLoad() {
        AccountClient.sharedInstance().accounts.removeAll(keepCapacity: true)
        let analyzebutton = UIBarButtonItem(title: "Analyze", style: UIBarButtonItemStyle.Plain, target: self, action: "Analyze:")
        self.navigationItem.rightBarButtonItem = analyzebutton
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        AccountClient.sharedInstance().getaccountlist(accesstoken, view: self.tableview)
        AccountClient.sharedInstance().getalltransactions("2014", accesstoken: self.accesstoken)
        
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
            self.income.text = "Total Income: \(AccountClient.sharedInstance().totalincome)"
            self.Expense.text = "Total Expense: \(AccountClient.sharedInstance().totalexpense)"
            self.Saving.text = "You've saved \(AccountClient.sharedInstance().totalincome-AccountClient.sharedInstance().totalexpense) in 2014"
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
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }


}

