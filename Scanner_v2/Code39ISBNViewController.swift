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
   
    //MARK: Function Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createActivityIndicator() //Create the fullscreen activity indicator
        

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    override func viewDidAppear(animated: Bool) {
        
        
        //Reload stuff if they exist
        if (Barcode.ISBN != ""){
            //ISBNView.backgroundColor = UIColor.greenColor()
            isbnCheckImg.image = UIImage(named: "files/icons/check")
            txtISBN.text = Barcode.ISBN
        }
        if(Barcode.CODE39 != ""){
            //Code39View.backgroundColor = UIColor.greenColor()
            code39CheckImg.image = UIImage(named: "files/icons/check")
            txtCode39.text = Barcode.CODE39
        }
        if(Barcode.DDC != ""){
            ddcCheckImg.image = UIImage(named: "files/icons/check")
            txtDDC.text = Barcode.DDC
        }
        if(Barcode.DONOR_EMAIL != ""){
            txtDonorEmail.text = Barcode.DONOR_EMAIL
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
    
    //var parameter_isbn:String!
    //var parameter_code39:String!
    
    //Auth struct contained in pass.swift
    let user = Auth.user
    let password = Auth.pass
    
    
    var myActivityIndicator:UIActivityIndicatorView!
    var myActivityIndicatorBackground:UIView!
    
    
    var hasBeenChecked = false
    var code39 = ""
    var ISBN = ""
    var ddc = ""
    var donorEmail = ""
    
    
    //MARK: Outlets
    
    @IBOutlet weak var txtDonorEmail: UITextField!
    @IBOutlet weak var txtDDC: UITextField!
    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var txtCode39: UITextField!
    
    
    
    //@IBOutlet weak var ISBNView: UIView!
    //@IBOutlet weak var Code39View: UIView!
   
    @IBOutlet weak var btnConfirmOutlet: UIButton!
    
    //@IBOutlet weak var lblBBC: UILabel!
    //@IBOutlet weak var lblBookTitle: UILabel!
    @IBOutlet weak var isbnCheckImg: UIImageView!
    @IBOutlet weak var code39CheckImg: UIImageView!
    @IBOutlet weak var ddcCheckImg: UIImageView!
    
    @IBOutlet weak var emailCheckImg: UIImageView!
    
    @IBOutlet weak var outputText: UITextView!
    
    
    
    //MARK: Text field actions
    @IBAction func touchInsideISBN(sender: AnyObject) {
        self.txtISBN.keyboardType = UIKeyboardType.NumberPad
    }
    
    @IBAction func touchInsideCode39(sender: AnyObject) {
        self.txtCode39.keyboardType = UIKeyboardType.NumberPad
    }
    
    
    @IBAction func touchInsideDDC(sender: AnyObject) {
        self.txtDDC.keyboardType = UIKeyboardType.NumberPad
    }
    
    
    @IBAction func touchInsideEmail(sender: AnyObject) {
        self.txtDonorEmail.keyboardType = UIKeyboardType.EmailAddress
        
        //shift view so that field can be seen
        self.view.frame.origin.y -= 150
    }
    
    @IBAction func touchOutsideEmail(sender: AnyObject) {
        self.view.frame.origin.y += 150
        Barcode.DONOR_EMAIL = txtDonorEmail.text!
    }
    
    
    
    //MARK: Button Presses
    
    @IBAction func btnClear(sender: AnyObject) {
        clearFields()
    }
    
    
    //Set code type for Scanner for Global setting
    @IBAction func btnCode39(sender: UIButton) {
        CodeType.type = "CODE39" //set the code type for the scanner
    }

    
    @IBAction func btnISBN(sender: UIButton) {
        CodeType.type = "ISBN" //set the code type for the scanner
    }
    
 
    //Main function, contains most program logic
    @IBAction func btnConfirm(sender: AnyObject) {
    
        if hasBeenChecked == false{
        //Check to see if fields have been filled out
            
            //Grab fields from text boxes
            code39 = txtCode39.text!
            ISBN = txtISBN.text!
            ddc = txtDDC.text!
            donorEmail = txtDonorEmail.text!
            
            Barcode.CODE39 = code39
            Barcode.ISBN = ISBN
            Barcode.DONOR_EMAIL = donorEmail
            Barcode.DDC = ddc
            
            //Logic for if fields have been filled out
            if (Barcode.CODE39 != "" && Barcode.ISBN != "") { //Good, Fields are not empty
                isbnCheckImg.image = UIImage(named: "files/icons/check")
                code39CheckImg.image = UIImage(named: "files/icons/check")
                btnConfirmOutlet.setTitle("Confirm", forState: UIControlState.Normal)
                hasBeenChecked = true
                //self.parameter_isbn = self.txtISBN.text  //Grab isbn from text box
                
                //getByISBN(parameter_isbn)
                //getDDC(parameter_isbn)
                getByISBN(Barcode.ISBN)
                getDDC(Barcode.ISBN)
                
            }else if(Barcode.CODE39 != "" && Barcode.ISBN == ""){
                code39CheckImg.image = UIImage(named: "files/icons/check")
                isbnCheckImg.image = UIImage(named: "files/icons/x-mark")
                hasBeenChecked = false
            }else if(Barcode.CODE39 == "" && Barcode.ISBN != ""){
                code39CheckImg.image = UIImage(named: "files/icons/x-mark")
                isbnCheckImg.image = UIImage(named: "files/icons/check")
                hasBeenChecked = false
            }else{ //no fields are filled in
                code39CheckImg.image = UIImage(named: "files/icons/x-mark")
                isbnCheckImg.image = UIImage(named: "files/icons/x-mark")
                hasBeenChecked = false
            }
            
        }else{ //if hasbeenchecked == true
            
            //Grab isbn and code39 from text box
            //parameter_isbn = self.txtISBN.text
            //parameter_code39 = self.txtCode39.text
            
            //uploadBook(parameter_code39, isbn: parameter_isbn, ddc: Barcode.DDC)
            
            //Use entered DDC
            Barcode.DDC = txtDDC.text!
            
            print(Barcode.DONOR_EMAIL)
            print(Barcode.DDC)
            
            uploadBook(Barcode.CODE39, isbn: Barcode.ISBN, ddc: Barcode.DDC, donorEmail: Barcode.DONOR_EMAIL)
            
            clearFields()
            
        }//End hasBeenChecked If
    }//End Button Confirm
    
    

    
    
    
    //MARK: Alamofire HTTP requests
    
    func uploadBook(code39: String, isbn: String, ddc: String, donorEmail: String){ //Upload book to API using ISBN and internal code39
        
        showActivityIndicator() //Begin activity indicator
        
        let parameters = ["isbn": isbn ,"barcode": code39, "ddc": ddc, "donor_email" : donorEmail]
        
        //start alamofire instance
        let manager_post = Alamofire.Manager.sharedInstance
        manager_post.session.configuration.HTTPAdditionalHeaders = ["X-Requested-With" : "XMLHttpRequest", "Content-Type" : "application/json", "Accept" : "application/json"]
        
        manager_post.request(.POST, "http://www.books4equality.com/api/books", parameters: parameters, encoding: .JSON).authenticate(user: user, password: password).responseJSON
            { response in switch response.result {
            case .Success(let JSON):    //If API Returns .JSON Successfully
                print("Success with JSON: \(JSON)") //Should return book info .JSON
                let t: AnyObject! = JSON["title"]
                let title = String(t)
    
                /*******CREATE UPLOAD CONFIRM ALERT   **********/
                let alertController = UIAlertController(title: "Nice.", message:
                    "\"" + title + "\"" + " was Successfully Uploaded.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                /******* END OF ALERT ************/
                
                self.removeActivityIndicator()  //remove activity indicator
                
            case .Failure(let error):  //Handle .JSON not being returned
                print("Request failed with error: \(error)")
                //self.lblBookTitle.text = "Error: Upload Failure!"
                self.outputText.text = "Error: Upload Failure!"
                //self.catOutput("Error: Upload Failure")
                self.removeActivityIndicator() //remove activity indicator
            }
        }
    }
    
    
    
    

    func getByISBN(isbn: String){//Get the book title from API by ISBN
        
        showActivityIndicator()
        
        let manager = Alamofire.Manager.sharedInstance
        // Add API key header to all requests make with this manager (i.e., the whole session)
        manager.session.configuration.HTTPAdditionalHeaders = ["X-Requested-With" : "XMLHttpRequest", "Content-Type" : "application/json", "Accept" : "application/json"]
        
        manager.request(.GET, "http://www.books4equality.com/search/\(isbn)").authenticate(user: user, password: password).responseJSON
            { response in switch response.result {
            case .Success(let JSON):
               // print("Success with JSON: \(JSON)")
                self.removeActivityIndicator()
                
                guard let t: AnyObject! = JSON["title"] else {
                    print("Error Unwrapping JSON")
                    //_ = "ERROR"
                }
                
                let title = String(t)
                //self.lblBookTitle.text = "Is this: \"" + title + "\"?" //set book title after retrieving JSON
                //self.outputText.text = "Is this: \"" + title + "\"?"
                //out = "Is this: \"" + title + "\"?"
                self.catOutput("Is this: \"" + title + "\"?")
                
            case .Failure(let error):
                print("ISBN Request failed with error: \(error)")
                //self.lblBookTitle.text = "Error: Didn't find book for given ISBN"
                //self.outputText.text = "Error: Didn't find book for given ISBN"
                //out = "Error: Didn't find book for given ISBN"
                self.catOutput("Error: Didn't find book for given ISBN")

                self.removeActivityIndicator()
                }
        }
    }
    
    
    
    func getDDC(isbn: String){//Get the Dewey Decimal Code from Classified API by ISBN
        
        //var out = ""
        
        showActivityIndicator()
        
        let urlString = "http://classify.oclc.org/classify2/Classify?isbn=\(isbn)&summary=true"
        
        let manager = Alamofire.Manager.sharedInstance
        manager.request(.GET, urlString).responseData{
            response in switch response.result{
            case .Success(let data):
                let ddc = self.findDDC(data)
                Barcode.DDC = ddc
                if (ddc == ""){
                    self.catOutput("No DDC, enter manually")
                }else{
                    self.catOutput("DDC is: \(ddc)")
                    self.txtDDC.text = ddc
                }
                self.removeActivityIndicator()
            case .Failure(let error):
                print("BBC Request failed with error: \(error)")
                //self.lblBBC.text = "Failure to find DDC"
                //self.outputText.text = "Failure to find DDC"
                self.catOutput("Failure to find DDC")
                self.removeActivityIndicator()
            }
        }
        
    }

    
    
    
    
    //MARK: MISC.
    
    //Required for outputting messsages in the outputText
    func catOutput(str:String){
        let currentStr = outputText.text
        if (currentStr == ""){
            outputText.text = str
        }else{
            outputText.text = currentStr + "\n" + str
        }
    }
    
    
    func findDDC(data: NSData) -> String {
        
        let xml = SWXMLHash.parse(data)
        
        guard xml else{
            print("XML Hash Error")
            return ("")
        }
        print(xml)
        
        guard let ddc: String! = xml["classify"]["recommendations"]["ddc"]["mostPopular"].element?.attributes["nsfa"] else {
            print("DDC Parse Error")
            return ("")
        }
        print(ddc)
        return ddc
    }
    
    
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
        Barcode.DDC = ""
        Barcode.DONOR_EMAIL = ""
        txtCode39.text = ""
        txtISBN.text = ""
        txtDonorEmail.text = ""
        txtDDC.text = ""
        //ISBNView.backgroundColor = UIColor.lightGrayColor()
        //Code39View.backgroundColor = UIColor.lightGrayColor()
        /*** replace with check mark  **/
        code39CheckImg.image = nil
        isbnCheckImg.image = nil
        ddcCheckImg.image = nil
        emailCheckImg.image = nil
        self.btnConfirmOutlet.setTitle("Check Book", forState: UIControlState.Normal)
        //lblBookTitle.text = ""
        //lblBBC.text = ""
        outputText.text = ""
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

    
    //9781932735659
    //9999999999

}//End View Controller
