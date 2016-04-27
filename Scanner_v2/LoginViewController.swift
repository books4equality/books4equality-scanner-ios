//
//  LoginViewController.swift
//  Scanner_v2
//
//  Created by Owner on 4/26/16.
//  Copyright © 2016 Books_For_Equality. All rights reserved.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let account = Locksmith.loadDataForUserAccount("b4e_login")!
        if(account["username"] == nil || account["password"] == nil){
            return
        }
    
        if (checkLogin(account["username"] as! String, password: account["password"] as! String)) {
            dismissLoginView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginAction(sender: AnyObject) {
        
        if (UsernameOutlet.text == "") {
            UsernameOutlet.backgroundColor = UIColor.redColor()
            return
        }
        if(PasswordOutlet.text == ""){
            PasswordOutlet.backgroundColor = UIColor.redColor()
            return
        }
        
        if (checkLogin(self.UsernameOutlet.text!, password: self.PasswordOutlet.text!)) {
            
            let dict = ["username":self.UsernameOutlet.text!, "password": self.PasswordOutlet.text!]
            
            try! Locksmith.saveData(dict, forUserAccount: "b4e_login")
            //let newDict = Locksmith.loadDataForUserAccount("b4e_login")!
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
 
    }
    
    @IBOutlet weak var UsernameOutlet: UITextField!
    
    @IBOutlet weak var PasswordOutlet: UITextField!

    
    let usernameKey = "UVM"
    let passwordKey = "password"
    
    func checkLogin(username: String, password: String ) -> Bool {
        if ((username == usernameKey) && (password == passwordKey)) {
            return true
        } else {
            return false
        }
    }
    
    func dismissLoginView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
