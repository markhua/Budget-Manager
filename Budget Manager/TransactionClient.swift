//
//  TransactionClient.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import Foundation
import UIKit

class TransactionClient {
    var transactions = [Transaction]()
    
    class func sharedInstance() -> TransactionClient {
        
        struct Singleton {
            static var sharedInstance = TransactionClient()
        }
        
        return Singleton.sharedInstance
    }
}

extension TransactionClient {
    
    // gettransactionlist method gets transactions from API and displays the result in the tableview
    func gettransactionlist(acctid: String!, token: String!, view: UITableView){
        let session = NSURLSession.sharedSession()
        let urlString = "https://tartan.plaid.com/connect?client_id=55ea43693b5cadf40371c50c&secret=095aa0bfc4ae585fb74b61ef6bc78c&access_token=\(token)"
        
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                if let response = parsedResult.valueForKey("transactions") as? [[String: AnyObject]]{
                    for transaction in response {
                        let accountid = transaction["_account"] as! String
                        if accountid == acctid {
                            let id = transaction["_id"] as! String
                            let amount = transaction["amount"] as! Double
                            let date = transaction["date"] as! String
                            let name = transaction["name"] as? String
                            let categories = transaction["category"] as? [String]
                            let t = Transaction(id: accountid, tranid: id, amt: amount, dat: date, nam: name, cat: categories)
                            TransactionClient.sharedInstance().transactions.append(t)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        view.reloadData()
                    }
                    
                }else{
                    println("error")
                }
            }
        }
        task.resume()
    }
    
}