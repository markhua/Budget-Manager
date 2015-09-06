//
//  TransactionViewController.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedacct: Account!
    var accesstoken: String!
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        account.text = "\(selectedacct.name!)"
        balance.text = "\(selectedacct.balance!)"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
        TransactionClient.sharedInstance().gettransactionlist(self.selectedacct.accountID!, token: self.accesstoken, view: self.tableview)
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
            if transaction.amount >= 0 {
                cell.textLabel?.text = "-\(transaction.amount)"
            }else{
                cell.textLabel?.text = "+\(-transaction.amount)"
            }
            cell.detailTextLabel?.text = "\(transaction.name) \nCard Type: \(transaction.category),\nDate: \(transaction.date)"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TransactionClient.sharedInstance().transactions.count
    }


}
