//
//  RegisterLogin.swift
//  LoginRegisterDomain
//
//  Created by Rahul's MacBook Pro on 04/08/18.
//  Copyright © 2018 Rahul M. All rights reserved.
//

import UIKit


class RegisterLogin: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var lbldomain: UILabel!
    @IBOutlet weak var titleLabeled: UILabel!
    var titleLabe = ""
    
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var btnsubmit: UIButton!

    var domainNames = [String]()
    var domainID = [Int]()
    var selectedID = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Passed Domains names: \(domainNames)")
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titleLabeled.text = titleLabe
        if titleLabe == "Login"{
            self.txtName.isHidden = true
        }else{
            self.txtName.isHidden = false
        }
    
        if (domainNames.count == 0){
            print("No values")
            let kUserDefault = UserDefaults.standard

            domainNames = kUserDefault.array(forKey: "DomainNames") as! [String]
            domainID = kUserDefault.array(forKey: "DomainID") as! [Int]
        }
        else{
        self.lbldomain.text = "Domain selected: \(domainNames[0])"
        selectedID = domainID[0]
        }

    }
    
    @IBAction func btnsubmitTapped(_ sender: AnyObject) {
        self.txtName.resignFirstResponder()
        self.txtpassword.resignFirstResponder()
        self.txtemail.resignFirstResponder()
        if titleLabe == "Login"{
            self.loginAPICall()
        }else{
            self.registerAPICall()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool    {
        return true;
    }
    
    public func numberOfComponents(in pickerView:  UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return domainNames.count
    }
    
    public func pickerView(_pickerView:UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return domainNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return domainNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let valueSelected = domainNames[row] as String
        selectedID = domainID[row]
        print("Selected ID: \(selectedID)")
        self.lbldomain.text = "Domain seleted: \(valueSelected)"
    }
    
    
    func loginAPICall() {
        let json: [String: Any] = ["domain":selectedID,
                                   "email":self.txtemail.text,
                                   "password":self.txtpassword.text]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http:// 13.127.73.24 /api/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                let alert = UIAlertController.init(title: "Notice", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        
        task.resume()

    }
    
    func registerAPICall() {
   
        let json: [String: Any] = ["domain":selectedID,
                                   "email":"\(txtemail.text!)",
                                   "name":"\(txtName.text!)",
                                   "password":"\(txtpassword.text!)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        print("Request:\(json)")
        // create post request
        let url = URL(string: "http://13.127.73.24/api/register")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                let alert = UIAlertController.init(title: "Notice", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if(responseJSON["success"] as! Bool){
                let dataRec = responseJSON["data"] as! NSDictionary
                let token = dataRec["token"] as! String
                    let permission = dataRec["permission"] as! String
                    let kUserDefault = UserDefaults.standard
                    kUserDefault.set(permission, forKey: "Permission")
                    kUserDefault.set(token, forKey: "Token")
                    kUserDefault.synchronize()
                    print("Token = \(token)")

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ScanQR")
                    self.present(controller, animated: true, completion: nil)
                    
                }
                else{
                    print("responseString = \(jsonData!)")

                }
            }
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
    
    
}
