//
//  ManualEntryViewController.swift
//  Scanner_v2
//
//  Created by Owner on 10/7/15.
//  Copyright © 2015 Books_For_Equality. All rights reserved.
//

import UIKit

class ManualEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lblCode39: UILabel!
    @IBOutlet weak var txtCode39: UITextField!
    @IBOutlet weak var lblISBN: UILabel!
    @IBOutlet weak var txtISBN: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtCode39.delegate = self
        self.txtISBN.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Populate textBoxes
    override func viewDidAppear(animated: Bool) {
        
        if (Barcode.ISBN != ""){
            txtISBN.text = Barcode.ISBN
            
        }
        if(Barcode.CODE39 != ""){
            txtCode39.text = Barcode.CODE39
            
        }
        
        
        
    }
    
  //  txtCode39.keyboardType = UIKeyboardType.PhonePad
   // txtCode39.returnKeyType = UIReturnKeyType.Done
    

    
    @IBAction func txtCode39Action(sender: AnyObject) {
        self.txtCode39.keyboardType = UIKeyboardType.PhonePad
        self.txtCode39.returnKeyType = UIReturnKeyType.Done
    }
    
    
    @IBAction func txtISBNAction(sender: AnyObject) {
        self.txtISBN.keyboardType = UIKeyboardType.PhonePad
        self.txtISBN.returnKeyType = UIReturnKeyType.Done
    }
    
    
    //keyboard goes away when touching away from textField
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //keyboard goes away when touching return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //Vars for btnDone
    var code39 = ""
    var ISBN = ""
    
    //Set globals when done
    @IBAction func btnDone(sender: UIButton) {
        
        code39 = txtCode39.text!
        ISBN = txtISBN.text!
        
        
        Barcode.CODE39 = code39
        Barcode.ISBN = ISBN
        
    }
    
}
