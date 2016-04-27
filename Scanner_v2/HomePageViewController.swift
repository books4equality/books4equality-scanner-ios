//
//  HomePageViewController.swift
//  Scanner_v2
//
//  Created by Owner on 4/26/16.
//  Copyright © 2016 Books_For_Equality. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pull up the login view controller
        let loginViewController = LoginViewController()
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutAction(sender: AnyObject) {
        let keychain = Keychain()
        keychain["b4e_username"] = nil
        keychain["b4e_password"] = nil
        //Pull up the login view controller
        let loginViewController = LoginViewController()
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }

    


}
