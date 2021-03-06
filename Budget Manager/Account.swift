//
//  Account.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import Foundation

// The class Account is used to get the parsed data of user's bank accounts

class Account: NSObject{
    
    var accountID : String?
    var balance : Double?
    var name: String?
    var type: String?
    var number: String?
    
    override init(){
        accountID = ""
        balance = 0
        name = ""
        type = ""
        number = ""
    }
    
    init(id: String!, bal: Double!, name: String!, type: String!, number: String!){
        self.accountID = id
        self.balance = bal
        self.name = name
        self.type = type
        self.number = number
    }
    
}
