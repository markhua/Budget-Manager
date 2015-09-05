//
//  TransactionViewController.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var accountid = ""
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TransactionClient.sharedInstance().gettransactionlist(self.accountid, view: self.tableview)
        self.tableview.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "TransactionCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        println(TransactionClient.sharedInstance().transactions.count)
        println(indexPath.row)
        let transaction = TransactionClient.sharedInstance().transactions[indexPath.row]
        
        dispatch_async(dispatch_get_main_queue()){
            cell.textLabel?.text = transaction.name
            cell.detailTextLabel?.text = "Card Type: \(transaction.category), Number: xxxxx \(transaction.amount), \nCurrent Balance: \(transaction.date)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TransactionClient.sharedInstance().transactions.count
    }


}
