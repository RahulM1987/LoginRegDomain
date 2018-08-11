//
//  ScanQR.swift
//  LoginRegisterDomain
//
//  Created by Rahul's MacBook Pro on 05/08/18.
//  Copyright © 2018 Rahul M. All rights reserved.
//

import UIKit
import CoreImage

class ScanQR: UIViewController {

    @IBOutlet weak var imageQR: UIImageView!
    @IBOutlet weak var btnscan: UIButton!

    @IBOutlet weak var lbltoken: UILabel!
    @IBOutlet weak var lbldisplayQr: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageQR.image = UIImage.init(named: "tlb-qr")
        let kUserDefault = UserDefaults.standard
        if(kUserDefault.value(forKey: "Permission") == nil){
            self.lbltoken.text = ""
        }
        else{
        self.lbltoken.text = "\(kUserDefault.value(forKey: "Permission")!): \(kUserDefault.value(forKey: "Token")!)"}

    }
    
    
//    func performQRCodeDetection(image: CIImage) -> (outImage: CIImage?, decode: String) {
//        var resultImage: CIImage?
//        var decode = ""
//        if let detector = detector {
//            let features = detector.featuresInImage(image)
//            for feature in features as! [CIQRCodeFeature] {
//                resultImage = drawHighlightOverlayForPoints(image,
//                                                            topLeft: feature.topLeft,
//                                                            topRight: feature.topRight,
//                                                            bottomLeft: feature.bottomLeft,
//                                                            bottomRight: feature.bottomRight)
//                decode = feature.messageString
//            }
//        }
//        print("\(decode) --- \(resultImage)")
//        return (resultImage, decode)
//    }

    
    @IBAction func btnScanTap(_ sender: AnyObject) {
        //performQRCodeDetection(image: self.imageQR)
        self.imageQR.image = UIImage.init(named: "tlb-qr")
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let ciImage:CIImage = CIImage(image:self.imageQR.image!)!
        var qrCodeLink=""
        
        let features=detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }
        
        if qrCodeLink=="" {
            print("nothing")
        }else{
            print("message: \(qrCodeLink)")
            self.lbldisplayQr.text = "Scanned QR code: \(qrCodeLink)"
        }
    }
    
    
    
    func scanImageQR()
    {
        
        let image = UIImage.init(named: "tlb-qr")
        
        let ciimage = CIImage.init(image: image!)
        
        let detectorOptns = [CIDetectorAccuracy:CIDetectorAccuracyHigh]
        
        let qrdetector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: detectorOptns)
        
        let features = qrdetector?.features(in: ciimage!)
        
        let fetrue = CIQRCodeFeature()
        
        for fetrue in features! as! [CIQRCodeFeature]
        {
            let stringss = "\(fetrue.messageString)"
            print(stringss)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
