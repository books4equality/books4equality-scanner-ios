//
//  ViewController.swift
//  Scanner_v2
//
//  Created by Owner on 9/23/15.
//  Copyright © 2015 Books_For_Equality. All rights reserved.
//
/*
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}*/

import UIKit



class ViewController: UIViewController,
ScannerViewControllerDelegate {
    @IBOutlet weak var lblBarcode: UILabel!
    var scannerVC: ScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        scannerVC = segue.destinationViewController as! ScannerViewController
//        scannerVC.delegate = self
//    }
    func barcodeObtained(viewController: ScannerViewController, data: String) {
        self.lblBarcode.text = data
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


