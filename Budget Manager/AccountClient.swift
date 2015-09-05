//
//  AccountClient.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import Foundation
import UIKit

class AccountClient {
    var accounts = [Account]()
    
    class func sharedInstance() -> AccountClient {
        
        struct Singleton {
            static var sharedInstance = AccountClient()
        }
        
        return Singleton.sharedInstance
    }
}

extension AccountClient {
    
    func getaccountlist(accesstoken: String, view: UITableView){
        let session = NSURLSession.sharedSession()
        let urlString = "https://tartan.plaid.com/connect?client_id=55ea43693b5cadf40371c50c&secret=095aa0bfc4ae585fb74b61ef6bc78c&access_token=\(accesstoken)"
        
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                println("Could not complete the request \(error)")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                if let response = parsedResult.valueForKey("accounts") as? [[String: AnyObject]]{
                    for account in response {
                        let accountid = account["_id"] as! String
                        let accounttype = account["type"] as! String
                        if let balance = account["balance"] as? [String: AnyObject]{
                            let currentbal = balance["current"] as! Double
                            if let meta = account["meta"] as? [String: AnyObject]{
                                let accountname = meta["name"] as! String
                                let number = meta["number"] as! String
                                let acct = Account(id: accountid, bal: currentbal, name: accountname, type: accounttype, number: number)
                                self.accounts.append(acct)
                            }else{
                                println("error")
                            }
                        }else{
                            println("error")
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
    
    func userlogin (username: String, password: String, type: String, completionHandler: (success: Bool, String: String?, question: String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://tartan.plaid.com/connect?client_id=55ea43693b5cadf40371c50c&secret=095aa0bfc4ae585fb74b61ef6bc78c&type=\(type)&username=plaid_test&password=plaid_good")!)
        request.HTTPMethod = "POST"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil { // Handle error...
            completionHandler(success: false, String: "Connection Failed", question: nil)
        } else {
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
        
            if let error = parsingError {
                completionHandler(success: false, String: "Post error", question: nil)
            }else{
                println(parsedResult)
                if let accesstoken = parsedResult["access_token"] as? String{
                    if let mfa = parsedResult["mfa"] as? [[String: AnyObject]]{
                        if let mfamessage = mfa[0]["question"] as? String {
                            completionHandler(success: true, String: accesstoken, question: mfamessage)
                        }
                    }
                    if let mfa = parsedResult["mfa"] as? [String: AnyObject]{
                        if let mfamessage = mfa["message"] as? String {
                            completionHandler(success: true, String: accesstoken, question: mfamessage)
                        }
                    }
                    if let accounts = parsedResult["accounts"] as? [[String: AnyObject]] {
                        completionHandler(success: true, String: accesstoken, question: nil)
                    }
                }else{
                    completionHandler(success: false, String: "Login error", question: nil)
                }
                }
            }
        }
        task.resume()
    }
    
    func mfalogin(accesstoken: String, mfatext1: String, completionHandler: (success: Bool, mfa: Bool, String: String?)->Void){
        let request = NSMutableURLRequest(URL: NSURL(string:"https://tartan.plaid.com/auth/step?client_id=55ea43693b5cadf40371c50c&secret=095aa0bfc4ae585fb74b61ef6bc78c&mfa=\(mfatext1)&access_token=\(accesstoken)")!)
        request.HTTPMethod = "POST"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(success: false, mfa: false, String: "Connection error")
                return
            } else {
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                if let error = parsingError {
                    completionHandler(success: false, mfa: false, String: "Post error")
                }else{
 
                    if let message = parsedResult["message"] as? String{
                        println(message)
                        completionHandler(success: false, mfa: false, String: message)
                    }else{
                        if let mfa = parsedResult["mfa"] as? [[String: AnyObject]]{
                            if let mfamessage = mfa[0]["question"] as? String {
                                completionHandler(success: false, mfa: true, String: mfamessage)
                            }
                        }
                        else{
                            completionHandler(success: true, mfa: false, String: nil)
                        }
                    }

                }
            }
        }
        task.resume()
    }
    
}

