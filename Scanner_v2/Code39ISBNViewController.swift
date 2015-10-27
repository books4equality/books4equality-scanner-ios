//
//  Code39ISBNViewController.swift
//  Scanner_v2
//
//  Created by Owner on 10/6/15.
//  Copyright © 2015 Books_For_Equality. All rights reserved.
//

import UIKit
import Alamofire


class Code39ISBNViewController: UIViewController, UITextFieldDelegate {
    
   // @IBOutlet weak var imgInOut: UIImageView!
    
   
    
    //let parameters = ["isbn":"9780395357149"]
    var parameter_isbn:String!
    var parameter_code39:String!
    
    //Auth struct contained in pass.swift
    let user = Auth.user
    let password = Auth.pass
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imgInOut.image = UIImage(named: "in_symbol.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //This is a delay that actually works
    //Type:Double of seconds
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    


    
    @IBOutlet weak var txtISBN: UITextField!
    
    @IBOutlet weak var txtCode39: UITextField!
    
    @IBOutlet weak var ISBNView: UIView!
    
    @IBOutlet weak var Code39View: UIView!
    
    //for title output
    @IBOutlet weak var lblBookTitle: UILabel!
    
    
    //Loads the Global ISBN and Code39 into labels
    override func viewDidAppear(animated: Bool) {
        
        if (Barcode.ISBN != ""){
            ISBNView.backgroundColor = UIColor.greenColor()
            txtISBN.text = Barcode.ISBN
        }
        if(Barcode.CODE39 != ""){
            Code39View.backgroundColor = UIColor.greenColor()
            txtCode39.text = Barcode.CODE39
        }
        
        btnConfirmOutlet.setTitle("Check Book", forState: UIControlState.Normal)
    
    }
    
    
    
    
    @IBAction func btnClear(sender: AnyObject) {
        
        /*
        Resets:
        1. Globals for ISBN and Code 39
        2. Labels
        3. Background color for view containers
        */
        
        Barcode.CODE39 = ""
        Barcode.ISBN = ""
        
        txtCode39.text = ""
        txtISBN.text = ""
        
        ISBNView.backgroundColor = UIColor.lightGrayColor()
        Code39View.backgroundColor = UIColor.lightGrayColor()
        
        lblBookTitle.text = ""
        
        
    }
    
    
    //Set code type for Scanner for Global setting
    @IBAction func btnCode39(sender: UIButton) {
        CodeType.type = "CODE39"
    }

    
    @IBAction func btnISBN(sender: UIButton) {
        CodeType.type = "ISBN"
    }
    
 
    @IBOutlet weak var btnConfirmOutlet: UIButton!
    
    var myActivityIndicator:UIActivityIndicatorView!
    var myActivityIndicatorBackground:UIView!
    
    var myActivityIndicatorBookSearch:UIActivityIndicatorView!
    var myActivityIndicatorBackgroundBookSearch:UIView!
    
    var hasBeenChecked = false
    var code39 = ""
    var ISBN = ""
    
    @IBAction func btnConfirm(sender: AnyObject) {
        
        //Get Screen Dimentions
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        
        if hasBeenChecked == false{
            
            
            
            code39 = txtCode39.text!
            ISBN = txtISBN.text!
            
            Barcode.CODE39 = code39
            Barcode.ISBN = ISBN
            
            //Determine which field have been filled out
            //This if statement contains all of the database requests 
            //For Books title search
            if (Barcode.CODE39 != "" && Barcode.ISBN != "") {
                //Yay
                Code39View.backgroundColor = UIColor.greenColor()
                ISBNView.backgroundColor = UIColor.greenColor()
                
                
                btnConfirmOutlet.setTitle("Confirm", forState: UIControlState.Normal)
                hasBeenChecked = true
                
                
                /********Activity indicator background             *********************/
                
                self.myActivityIndicatorBookSearch = UIActivityIndicatorView(frame: CGRectMake(0,0,screenWidth,screenHeight)) as UIActivityIndicatorView;
                self.myActivityIndicatorBookSearch.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                
                self.myActivityIndicatorBackgroundBookSearch = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight)) as UIView;
                
                self.myActivityIndicatorBackgroundBookSearch.backgroundColor = UIColor(white: 1, alpha: 0.75)
                
                self.view.addSubview(self.myActivityIndicatorBackgroundBookSearch)
                
                self.view.addSubview(self.myActivityIndicatorBookSearch)
                
                self.myActivityIndicatorBookSearch.startAnimating()
                
                /********** Activity indicator background      ************/
                
                
                
               let manager = Alamofire.Manager.sharedInstance
                // Add API key header to all requests make with this manager (i.e., the whole session)
               manager.session.configuration.HTTPAdditionalHeaders = ["X-Requested-With" : "XMLHttpRequest", "Content-Type" : "application/json", "Accept" : "application/json"]
                
                //let parameters = ["isbn":"9780395357149"]
               // var parameters:String!
                
                //Auth struct contained in pass.swift
                //let user = Auth.user
                //let password = Auth.pass
                
                //Grab isbn from text box
                self.parameter_isbn = self.txtISBN.text
                
        
                manager.request(.GET, "http://www.books4equality.com/search/\(self.parameter_isbn)").authenticate(user: user, password: password).responseJSON
                    { response in switch response.result {
                    case .Success(let JSON):
                        print("Success with JSON: \(JSON)")
                        
                        //end activity indicator
                        self.myActivityIndicatorBookSearch.stopAnimating()
                        self.myActivityIndicatorBackgroundBookSearch.removeFromSuperview()
                        
                        let title = JSON["title"]
                        print(title)
                        
                        //parse "optional()" out of the string
                        let titleString = String(title)
                        
                        let splitTitleArr0 = titleString.componentsSeparatedByString("(")
   
                        let mainTitle0 = splitTitleArr0[1]
                        
                        let splitTitleArr1 = mainTitle0.componentsSeparatedByString(")")
                        
                        let mainTitle1 = splitTitleArr1[0]
                        
                        //set book title after retrieving JSON
                        
                        self.lblBookTitle.text = "Is this: \"" + String(mainTitle1) + "\" ?"
                        
                        
                                           case .Failure(let error):
                        print("Request failed with error: \(error)")
                            self.lblBookTitle.text = "Error: Didn't find book for given ISBN"
                        
                            //end activity indicator
                            self.myActivityIndicatorBookSearch.stopAnimating()
                            self.myActivityIndicatorBackgroundBookSearch.removeFromSuperview()
                        }
                }
                
                        //Get rid of activity spinner
                
              /*  delay(0.25){
                        self.myActivityIndicatorBookSearch.stopAnimating()
                        self.myActivityIndicatorBackgroundBookSearch.removeFromSuperview()
                } */
                
                
            }else if(Barcode.CODE39 != "" && Barcode.ISBN == ""){
                
                Code39View.backgroundColor = UIColor.greenColor()
                ISBNView.backgroundColor = UIColor.lightGrayColor()
                
                hasBeenChecked = false
            }else if(Barcode.CODE39 == "" && Barcode.ISBN != ""){
                
                Code39View.backgroundColor = UIColor.lightGrayColor()
                ISBNView.backgroundColor = UIColor.greenColor()
                
                hasBeenChecked = false
                
            }else{
                
                Code39View.backgroundColor = UIColor.lightGrayColor()
                ISBNView.backgroundColor = UIColor.lightGrayColor()
                
                hasBeenChecked = false
                
            }

            
            
        }else{//if hasbeenchecked == true
        
        //initialize activity indicator View
        self.myActivityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,screenWidth,screenHeight)) as UIActivityIndicatorView;
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        
            /********Activity indicator background             *********************/
        
            self.myActivityIndicatorBackground = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeight)) as UIView;
            
            self.myActivityIndicatorBackground.backgroundColor = UIColor(white: 1, alpha: 0.75)
            
            self.view.addSubview(myActivityIndicatorBackground)
        
            /***************************************/
        
        
            /******************** CREATE ACTIVITY INDICATOR AND SHOW IN MIDDLE OF SCREEN **********/
            self.view.addSubview(myActivityIndicator)

            self.myActivityIndicator.startAnimating()
            
            
            
            //Grab isbn and code39 from text box
            parameter_isbn = self.txtISBN.text
            parameter_code39 = self.txtCode39.text
            
            let parameters = ["isbn": parameter_isbn ,"barcode": parameter_code39]
            
            //start alamofire instance
            let manager_post = Alamofire.Manager.sharedInstance
            manager_post.session.configuration.HTTPAdditionalHeaders = ["X-Requested-With" : "XMLHttpRequest", "Content-Type" : "application/json", "Accept" : "application/json"]
            
            manager_post.request(.POST, "http://www.books4equality.com/api/books", parameters: parameters, encoding: .JSON).authenticate(user: user, password: password).responseJSON
                { response in switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    //end activity indicator
                    self.myActivityIndicatorBookSearch.stopAnimating()
                    self.myActivityIndicatorBackgroundBookSearch.removeFromSuperview()
                    
                    /*******CREATE UPLOAD ALERT   **********/
                
                
                
                    let alertController = UIAlertController(title: "Nice.", message:
                        "The Book was Successfully Uploaded.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    /******* END OF ALERT ************/
                    
                  
                    
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    self.lblBookTitle.text = "Error: Upload Failure!"
                    
                    //Get rid of background and indicator after upload
                    self.myActivityIndicatorBackground.removeFromSuperview()
                    self.myActivityIndicator.stopAnimating()
                    
                
              
                    
                    }
                    
            }
                
                
                
                
                /*******  Pretending to work more, Clear    **/
                
                //CLEAR GLOBALS
                Barcode.CODE39 = ""
                Barcode.ISBN = ""
                
                //CLEAR LABELS
                self.txtCode39.text = ""
                self.txtISBN.text = ""
                
                //CHANGE BACK BACKGROUND CLRS
                self.ISBNView.backgroundColor = UIColor.lightGrayColor()
                self.Code39View.backgroundColor = UIColor.lightGrayColor()
                
                self.btnConfirmOutlet.setTitle("Check Book", forState: UIControlState.Normal)
                
                self.lblBookTitle.text = ""
                
                /********   END CLEAR    ***************/
                
          
            
            hasBeenChecked = false
            
        }//End hasBeenChecked If
    
    }//End Button Confirm
    
    
    
    //keyboard goes away when touching away from textField
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //keyboard goes away when touching return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Alamofire http requests
    


}//End View Controller
