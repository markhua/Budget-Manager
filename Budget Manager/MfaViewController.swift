//
//  MfaViewController.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import UIKit

class MfaViewController: UIViewController {
    
    @IBOutlet weak var mfatext1: UITextField!
    var accesstoken: String!
    var question: String!
    
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var bottomlabel: UILabel!
    @IBOutlet weak var titlelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dispatch_async(dispatch_get_main_queue()){
            self.titlelabel.text = "MFA security check:"
            self.toplabel.text = self.question
            self.bottomlabel.text = ""
            println(self.question)
        }
    }
    
    @IBAction func loginMFA(sender: UIButton) {
        AccountClient.sharedInstance().mfalogin(accesstoken, mfatext1: mfatext1.text) {
            success, mfa, string in
            if (success){
                let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("AccountViewController") as! ViewController
                detailController.accesstoken = self.accesstoken
                dispatch_async(dispatch_get_main_queue()){
                    self.bottomlabel.text = ""
                    self.navigationController!.pushViewController(detailController, animated: true)
                }
            } else if (mfa){
                println(string)
                dispatch_async(dispatch_get_main_queue()){
                    self.toplabel.text = string
                    self.bottomlabel.text = ""
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.bottomlabel.text = string
                }
            }
        }
    }
    
    
}

