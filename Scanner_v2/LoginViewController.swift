//
//  LoginViewController.swift
//  Scanner_v2
//
//  Created by Owner on 4/26/16.
//  Copyright © 2016 Books_For_Equality. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class LoginViewController: UIViewController {
    
    var myActivityIndicator:UIActivityIndicatorView!
    var myActivityIndicatorBackground:UIView!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
        self.PasswordOutlet.secureTextEntry = true
    }
    
    override func viewDidAppear(animated: Bool) {
        if let account = Locksmith.loadDataForUserAccount("b4e_login"){
            checkLogin(account["username"] as! String, password: account["password"] as! String)
            }else{
                print("Keychain not present")
                return
            }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
        
        checkLogin(self.UsernameOutlet.text!, password: self.PasswordOutlet.text!)
            //print(Locksmith.loadDataForUserAccount("b4e_login"))
            //self.dismissLoginView()

            //let newDict = Locksmith.loadDataForUserAccount("b4e_login")!
 
    }
    
    @IBOutlet weak var UsernameOutlet: UITextField!
    
    @IBOutlet weak var PasswordOutlet: UITextField!
    
    //let usernameKey = "UVM"
    //let passwordKey = "password"
    
    func checkLogin(username: String, password: String ) {
        
        var valid: Bool = false
        
        let url = "http://www.books4equality.com/schools/login"
        //let url = "http://localhost:3200/schools/login"
        
        showActivityIndicator() //Begin activity indicator
        
        let headers = [
            "Content-Type": "application/JSON"
        ]
        
        let parameters = [
            "schoolID": username,
            "password": password,
        ]
        
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: headers)
            .response { request, response, data, error in
                if(error != nil){
                    print(error)
                }
                
                let resString: String?
                
                if let status = response?.statusCode {
                    print(status)
                    switch (status){
                    case 204:
                        resString = "Successful Login"
                        valid = true
                        break;
                    case 500:
                        resString = "Server Error"
                        break;
                    case 401:
                        resString = "Bad User/Pass combo"
                        break;
                    case 400:
                        resString = "Malformed Query"
                        break;
                    default:
                        resString = "Unknown failure/ bad status code"
                        break;
                    }
                    
                }else{
                    resString = "No status code recieved"
                }
                
                self.removeActivityIndicator()
                
                if(valid){
                    
                    //Save valid credentials to Keychain
                    let dict = ["username":self.UsernameOutlet.text!, "password": self.PasswordOutlet.text!]
                    //TODO: Add update for locksmith if the info already exists
                    do{
                        try Locksmith.saveData(dict, forUserAccount: "b4e_login")
                    } catch {
                        print("Locksmith save Error")
                    }
                    
                    //Alert the user that Login was successful
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Nice.", message: resString!, preferredStyle: .Alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                        self.dismissLoginView()
                        
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                }else{
                    
                    //Alert the user that Login failed
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Uh Ohh", message: resString!, preferredStyle: .Alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("Dismiss Pressed")
                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    
                    // Present the controller
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
        }
        //valid = true -> good login
    }

    
    func dismissLoginView(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: Activity indicator
    func createActivityIndicator(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds  //Get Screen Dimentions
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        self.myActivityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,screenWidth,screenHeight)) as UIActivityIndicatorView;
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.myActivityIndicatorBackground = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight)) as UIView;
        self.myActivityIndicatorBackground.backgroundColor = UIColor(white: 1, alpha: 0.75)
    }


    func showActivityIndicator(){ //Shows activity Indicator
        self.view.addSubview(myActivityIndicatorBackground)
        self.view.addSubview(myActivityIndicator)
        self.myActivityIndicator.startAnimating()
    }


    func removeActivityIndicator(){ //Removes activity Indicator
        self.myActivityIndicator.stopAnimating()
        self.myActivityIndicator.removeFromSuperview()
        self.myActivityIndicatorBackground.removeFromSuperview()
    }

}
