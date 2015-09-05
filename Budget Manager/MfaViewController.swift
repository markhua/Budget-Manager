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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginMFA(sender: UIButton) {
        AccountClient.sharedInstance().mfalogin(accesstoken, mfatext1: mfatext1.text) {
            success, string in
            if (success){
                let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("AccountViewController") as! ViewController
                detailController.accesstoken = self.accesstoken
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController!.pushViewController(detailController, animated: true)
                }

            }
        }
    }
    
    
}

