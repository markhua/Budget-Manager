//
//  Transaction.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import Foundation

// Transaction is used to store data for parsed transaction results
class Transaction {
    var accountid = ""
    var transacid = ""
    var amount = 0.0
    var date = ""
    var name = ""
    var category = [String]()
    
    init(id: String, tranid: String, amt: Double, dat: String, nam: String?, cat: [String]?)
    {
        accountid = id
        transacid = tranid
        amount = amt
        date = dat
        if (nam != nil) {name = nam!}
        if (cat != nil) {category = cat!}
    }
}