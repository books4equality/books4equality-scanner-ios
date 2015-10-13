//  ViewController.swift
//  BFE_Scanner
//
//  Created by Owner on 9/23/15.
//  Copyright © 2015 Books_For_Equality. All rights reserved.
//

// Code for Scanner from https://github.com/bowst/barcode_scanner_demo 



//Allow "iPhone Developer: bquinn1992@gmail.com (BE3T2K8YDW)"


import UIKit
import AVFoundation

//---to be implemented by the view controller calling this view controller---
protocol ScannerViewControllerDelegate {
    
    //---close the current View controller and return the barcode obtained---
func barcodeObtained(viewController: ScannerViewController, data: String)

}




//For global access to detection Strings
struct Barcode {
    static var detectionString = ""
    static var ISBN = ""
    static var CODE39 = ""
}

//struct for access to code 39 or ISBN
struct CodeType {
    static var type = ""
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    
    @IBOutlet weak var btnExitScanner: UIButton!
    
    
    //Final String to be returned
    //var detectionString : String!
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var delegate: ScannerViewControllerDelegate?
    
    //var delegate: scannerViewControllerDelegate?
    var captureSession: AVCaptureSession!
    var device : AVCaptureDevice!
    var deviceInput: AVCaptureDeviceInput!
    var metadataOutput : AVCaptureMetadataOutput!
    //var previewLayer : AVCaptureVideoPreviewLayer!
    var barcodeCapturedView : UIView!
    var audioPlayer:AVAudioPlayer!

    
    //For Reticle
    var firstHighlightView : UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.bringSubviewToFront(self.highlightView)


        // Allow the view to resize freely
        self.highlightView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin,
            UIViewAutoresizing.FlexibleBottomMargin,
            UIViewAutoresizing.FlexibleLeftMargin,
            UIViewAutoresizing.FlexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        

        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        let error : NSError? = nil
        
        
        var input : AVCaptureDeviceInput?
        
        do {
            input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch _ {
            //Error handling, if needed
            print(error)
        }
        
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
        
        
        /**************   Creates a red reticle view **************/
        //Get Screen dimentions
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //create reticle subview
        var reticle:UIView!
        
        //Should adjust pretty well for any
        reticle = UIView(frame: CGRectMake(0 , (screenHeight / 2) - 10 , screenWidth , 25.0))
        reticle.backgroundColor = UIColor(red: 0.25, green: 0.5, blue: 1, alpha: 0.5)
        
        self.view.addSubview(reticle)
        /************  End Reticle   *********************************/
        
        
    }
    
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){
        
        var highlightViewRect = CGRectZero
        var barCodeObject : AVMetadataObject!
        
      /*  let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]  */
        
        
        //We only need Code39 & EAN13
        
        
        let barCodeTypes = [AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code]


        
        //for some reason code 39 is scanning for both types
        /*
        var barCodeTypes = []
        
        if CodeType.type == "ISBN" {
            barCodeTypes = [AVMetadataObjectTypeEAN13Code]
        } else if CodeType.type == "CODE39"{
            barCodeTypes = [AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code]
        }
        */
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType{
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    Barcode.detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    self.session.stopRunning()
                    break
                }
                
            }
            if Barcode.detectionString != "" {
                break;
            }
            else {
                Barcode.detectionString = "No barcode detected"
            }
            
        }
        
        
        //Selects which global to set depending on which button was pressed in Code39ISBN
        if CodeType.type == "ISBN" {
            Barcode.ISBN = Barcode.detectionString
            
        }else if CodeType.type == "CODE39"{
            Barcode.CODE39 = Barcode.detectionString
        }
        
        
        //Highlight capture rectangle
        self.highlightView.frame = highlightViewRect
        self.view.bringSubviewToFront(self.highlightView)
        
        
        delegate?.barcodeObtained(self, data: Barcode.detectionString)
        
        //Not working RN
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}