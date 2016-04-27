//
//  HomePageViewController.swift
//  Scanner_v2
//
//  Created by Owner on 4/26/16.
//  Copyright © 2016 Books_For_Equality. All rights reserved.
//

import UIKit
import Locksmith

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
        do{
            try Locksmith.deleteDataForUserAccount("b4e_login")
        } catch {
            print("Failure deleting Locksmith user account")
        }
        //Pull up the login view controller
        let loginViewController = LoginViewController()
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    

    @IBAction func SignoutAction(sender: AnyObject) {
        /*******CREATE UPLOAD CONFIRM ALERT   **********/
        let alertController = UIAlertController(title: "Oi!", message:
            "This here buddon dinae work yeet", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        /******* END OF ALERT ************/
    }
    


}
