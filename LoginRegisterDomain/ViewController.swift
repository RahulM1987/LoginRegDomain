//
//  ViewController.swift
//  LoginRegisterDomain
//
//  Created by Rahul's MacBook Pro on 04/08/18.
//  Copyright © 2018 Rahul M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var domains = [String]()
    var dID = [Int]()
    var lblTitl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeAPICall()
    }
    
    func makeAPICall()
    {
        let url = URL(string: "http://13.127.73.24/api/domains")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        //let postString = "id=13&name=Jack"
        //request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                  // check for fundamental networking error
                print("error=\(error)")
                print("error show=\(error?.localizedDescription)")
                if(self.domains.count == 0){
                    let kUserDefault = UserDefaults.standard
                    self.domains.append("Please try again later." )
                    self.dID.append(0 )
                    kUserDefault.set(self.domains, forKey: "DomainNames")
                    kUserDefault.set(self.dID, forKey: "DomainID")
                    kUserDefault.synchronize()}
                let alert = UIAlertController.init(title: "Notice", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {    // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let responseString = String(data: data, encoding: .utf8)
            let jsonDict = self.convertToDictionary(text: responseString!)
            let dataRec = jsonDict?["data"] as! NSDictionary
            let domainsArray = dataRec["domains"] as! NSArray
            for i in domainsArray{
                let dataRecd = i as! NSDictionary
                self.domains.append(dataRecd["domain"] as! String)
                self.dID.append(dataRecd["id"] as! Int)
            }
            
            let kUserDefault = UserDefaults.standard
                kUserDefault.set(self.domains, forKey: "DomainNames")
                kUserDefault.set(self.dID, forKey: "DomainID")
                kUserDefault.synchronize()
            
//            UserDefaults.standard.set(self.domains, forKey: "DomainNames")
//            UserDefaults.standard.set(self.dID, forKey: "DomainID")
//            UserDefaults.synchronize(true)
            print("Response = \(jsonDict!)")
            //print("responseString = \(self.domains)")
        }
        task.resume()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    @IBAction func btnLogin(_ sender: AnyObject) {
    lblTitl = "Login"
    }
    
    
    @IBAction func btnRegister(_ sender: AnyObject) {
        lblTitl = "Register"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterLoginSegue" {
            if let DVC = segue.destination as? RegisterLogin{
                DVC.domainNames = domains
                DVC.domainID = dID
                DVC.titleLabe = lblTitl
            } else {
                print("Data NOT Passed! destination vc is not set to firstVC")
            }
        } else { print("Id doesnt match with Storyboard segue Id") }
    }
    
}
    
