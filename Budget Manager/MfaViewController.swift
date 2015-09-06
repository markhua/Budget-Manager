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
        }
    }
    
    @IBAction func loginMFA(sender: UIButton) {
        
        if(mfatext1.text == ""){
            self.notificationmsg("Please fill the blank")
            return
        }
        
        for index in indices(mfatext1.text) {
            if mfatext1.text[index] == " " {
                self.notificationmsg("No space allowed")
                return
            }
        }
        
        
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

