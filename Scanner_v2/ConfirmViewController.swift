//
//  ConfirmViewController.swift
//  Scanner_v2
//
//  Created by Owner on 9/29/15.
//  Copyright © 2015 Books_For_Equality. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    
    var ISBN = Barcode.detectionString

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
            print(ISBN)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    


    

}
