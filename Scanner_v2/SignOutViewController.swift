//
//  Code39ISBNViewController.swift
//  Scanner_v2
//
//  Created by Owner on 10/6/15.
//  Copyright © 2015 Books_For_Equality. All rights reserved.
//

import UIKit
import Alamofire


class SignOutViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Function Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createActivityIndicator() //Create the fullscreen activity indicator
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        //Loads the Global ISBN and Code39 into labels
        if (Out_Barcode.email != ""){
            viewEmail.backgroundColor = UIColor.greenColor()
            txtEmail.text = Out_Barcode.email
        }
        if(Out_Barcode.CODE39 != ""){
            viewCode39.backgroundColor = UIColor.greenColor()
            txtCode39.text = Out_Barcode.CODE39
        }
        
        //Initialize Confirm button to "Check"
        btnConfirmOutlet.setTitle("Check Book", forState: UIControlState.Normal)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) { //keyboard goes away when touching away from textField
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {  //keyboard goes away when touching return key
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: Class Vars.
    
    var parameter_code39:String!
    var parameter_email:String!
    
    //Auth struct contained in pass.swift
    //let user = Auth.user
    //let password = Auth.pass
    
    
    var myActivityIndicator:UIActivityIndicatorView!
    var myActivityIndicatorBackground:UIView!
    
    
    var hasBeenChecked = false
    var code39 = ""
    var email = ""
    
    
    //MARK: Outlets
    

    @IBOutlet weak var txtCode39: UITextField!
    @IBOutlet weak var viewCode39: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnConfirmOutlet: UIButton!
    @IBOutlet weak var lblBookTitle: UILabel!
    
    @IBAction func btnCode39(sender: AnyObject) {
    }
    
    //MARK: Button Presses
    
    @IBAction func btnClear(sender: AnyObject) {
        clearFields()
    }
    
    
    //Main function
    @IBAction func btnConfirm(sender: AnyObject) {
        
        if hasBeenChecked == false{
            //Check to see if fields have been filled out
            
            //Grab fields from text boxes
            code39 = txtCode39.text!
            email = txtEmail.text!
            
            Out_Barcode.CODE39 = code39
            Out_Barcode.email = email
            
            //Logic for if fields have been filled out
            if (Out_Barcode.CODE39 != "" && Out_Barcode.email != "") { //Good, Fields are not empty
                viewCode39.backgroundColor = UIColor.greenColor()
                viewEmail.backgroundColor = UIColor.greenColor()
                btnConfirmOutlet.setTitle("Confirm", forState: UIControlState.Normal)
                hasBeenChecked = true
                self.parameter_email = self.txtEmail.text  //Grab isbn from text box
                
                getByCode39(code39)
                
            }else if(Out_Barcode.CODE39 != "" && Out_Barcode.email == ""){
                viewCode39.backgroundColor = UIColor.greenColor()
                viewEmail.backgroundColor = UIColor.lightGrayColor()
                hasBeenChecked = false
            }else if(Out_Barcode.CODE39 == "" && Out_Barcode.email != ""){
                viewCode39.backgroundColor = UIColor.lightGrayColor()
                viewEmail.backgroundColor = UIColor.greenColor()
                hasBeenChecked = false
            }else{ //no fields are filled in
                viewCode39.backgroundColor = UIColor.lightGrayColor()
                viewEmail.backgroundColor = UIColor.lightGrayColor()
                hasBeenChecked = false
            }
            
        }else{//if hasbeenchecked == true
            
            //Grab isbn and code39 from text box
            parameter_email = self.txtEmail.text
            parameter_code39 = self.txtCode39.text
            
            signOutBook(parameter_code39, isbn: parameter_email)
            clearFields()
            
        }//End hasBeenChecked If
    }//End Button Confirm
    
    
    
    
    
    
    //MARK: Alamofire http requests
    
    //TODO: change this to sign out instead of
    
    func signOutBook(code39: String, isbn: String){ //Upload book to API using ISBN and internal code39
        /*
        showActivityIndicator() //Begin activity indicator
        
        let parameters = ["isbn": isbn ,"barcode": code39]
        
        //start alamofire instance
        let manager_post = Alamofire.Manager.sharedInstance
        manager_post.session.configuration.HTTPAdditionalHeaders = ["X-Requested-With" : "XMLHttpRequest", "Content-Type" : "application/json", "Accept" : "application/json"]
        
        manager_post.request(.POST, "http://www.books4equality.com/api/books", parameters: parameters, encoding: .JSON).authenticate(user: user, password: password).responseJSON
            { response in switch response.result {
            case .Success(let JSON):    //If API Returns .JSON Successfully
                print("Success with JSON: \(JSON)") //Should return book info .JSON
                
                self.removeActivityIndicator()  //remove activity indicator
                
                /*******CREATE UPLOAD CONFIRM ALERT   **********/
                let alertController = UIAlertController(title: "Nice.", message:
                    "The Book was Successfully Uploaded.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                /******* END OF ALERT ************/
                
                
            case .Failure(let error):  //Handle .JSON not being returned
                self.removeActivityIndicator() //remove activity indicator
                print("Request failed with error: \(error)")
                self.lblBookTitle.text = "Error: Upload Failure!"
                
                }
        }
 */
    }
    
    
    
    //TODO: Make work
    
    
    
    func getByCode39(Code39: String){//Get the book title from API by ISBN
        
        
        /*
        showActivityIndicator()
        
        let manager = Alamofire.Manager.sharedInstance
        // Add API key header to all requests make with this manager (i.e., the whole session)
        manager.session.configuration.HTTPAdditionalHeaders = ["X-Requested-With" : "XMLHttpRequest", "Content-Type" : "application/json", "Accept" : "application/json"]
        
        manager.request(.GET, "http://www.books4equality.com/api/books/?barcode=\(self.code39)").authenticate(user: user, password: password).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                self.removeActivityIndicator()
                
                let title = JSON[0]["title"] //Get title from .JSON
                print(title)
                let titleString = String(title) //parse "optional()" out of the string
                let splitTitleArr0 = titleString.componentsSeparatedByString("(")
                let mainTitle0 = splitTitleArr0[1]
                let splitTitleArr1 = mainTitle0.componentsSeparatedByString(")")
                let mainTitle1 = splitTitleArr1[0]
                self.lblBookTitle.text = "Is this: \"" + String(mainTitle1) + "\"?" //set book title after retrieving JSON
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
                self.lblBookTitle.text = "Error: Didn't find book for given Code39"
                
                self.removeActivityIndicator()
                }
        }
 */
    }
    
    
    
    
    //MARK: MISC.
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func clearFields(){    //Clears all fields in view controller
        Barcode.CODE39 = ""
        Barcode.ISBN = ""
        txtCode39.text = ""
        txtEmail.text = ""
        viewCode39.backgroundColor = UIColor.lightGrayColor()
        viewEmail.backgroundColor = UIColor.lightGrayColor()
        self.btnConfirmOutlet.setTitle("Check Book", forState: UIControlState.Normal)
        lblBookTitle.text = ""
        hasBeenChecked = false
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
    
    
}//End View Controller
