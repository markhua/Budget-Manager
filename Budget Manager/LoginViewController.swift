//
//  LoginViewController.swift
//  Budget Manager
//
//  Created by Mark Zhang on 9/5/15.
//  Copyright (c) 2015 Mark Zhang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var textpicker: UIPickerView!
    var pickerDataSource = ["Amex", "Chase"]
    var bank = "amex"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textpicker.dataSource = self
        self.textpicker.delegate = self
    }

    @IBAction func login(sender: UIButton) {
        AccountClient.sharedInstance().userlogin(username.text, password: password.text, type: bank) { success, string in
            if (success) {
                println(string)
                let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MFAViewController") as! MfaViewController
                detailController.accesstoken = string!
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController!.pushViewController(detailController, animated: true)
                }
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerDataSource[row]
        var myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Courier", size: 13.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        return myTitle
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0)
        {
            bank = "amex"
        }
        else if(row == 1)
        {
            bank = "chase"
        }
    }

}
