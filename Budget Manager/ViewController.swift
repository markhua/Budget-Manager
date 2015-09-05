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
    
    override func viewDidLoad() {
        AccountClient.sharedInstance().accounts.removeAll(keepCapacity: true)
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view, typically from a nib.
        AccountClient.sharedInstance().getaccountlist(accesstoken, view: self.tableview)
        println(AccountClient.sharedInstance().accounts.count)
        
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
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }


}

