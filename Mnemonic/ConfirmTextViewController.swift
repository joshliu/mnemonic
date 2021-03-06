//
//  ConfirmTextViewController.swift
//  Mnemonic
//
//  Created by Avery Lamp on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConfirmTextViewController: UIViewController, TagViewControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var editTextField: UITextField!
    var jsonDict = Dictionary<String, Any>()
    
    @IBOutlet weak var addButton: UIButton!{
        didSet {
            addButton.isEnabled = false
            addButton.setTitleColor(UIColor.init(red: 255/255, green: 124/255, blue: 165/255, alpha: 1.0), for: UIControlState())
            addButton.setTitleColor(UIColor.lightGray, for: .disabled)
        }
    }
    
    let tagLimit = 6
    var tagViewController = TagViewController()
    var alertResponder: SCLAlertViewResponder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextField.delegate = self
        tagViewController.view = tagView
        tagViewController.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ConfirmPictureViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && editTextField.isEditing{
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.frame.origin.y = 0
                })
            }
        }
    }
    
    func dismissKeyboard(){
        dateTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        editTextField.resignFirstResponder()
    }
    
    
    @IBAction func textFieldChanged(_ sender: Any) {
        let textField = sender as! UITextField
        if ((textField.text?.characters.count)! > 0) {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
        
        
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        if (editTextField.text != nil  ) {
            let noSpacesText = editTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            if (noSpacesText == "") {
                return
            }
            tagViewController.addSingleTagView(noSpacesText)
            editTextField.text = ""
            addButton.isEnabled = false
            textFieldChanged(editTextField)
            editTextField.resignFirstResponder()
        }
        
    }
    
    func tagAdditionError(_ reason: String) {
        let alertView = SCLAlertView(appearance: SCLAlertView.defaultAppearance)
        alertResponder = alertView.showCustomDialog("Error", subTitle: "You can not have more than 6 tags, click to delete tags")
    }
    
    
    var lastTagClicked = ""
    
    func tagViewClicked(_ button: UIButton) {
        lastTagClicked = button.titleLabel!.text!
        let alertView = SCLAlertView(appearance: SCLAlertView.defaultAppearance)
        _ = alertView.addButton("Delete", target:self, selector:#selector(ProfileViewController.confirmDelete))
        alertResponder = alertView.showCustomDialog("Delete", subTitle: "Would you like to delete the \(lastTagClicked) tag?", color: UIColor(red: 1.000, green: 0.831, blue: 0.557, alpha: 1.00))
    }
    func confirmDelete(){
        tagViewController.removeTag(lastTagClicked)
        textFieldChanged(editTextField)
        if alertResponder != nil {
            alertResponder.close()
        }
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        jsonDict["date"] = dateTextField.text
        jsonDict["location"] = locationTextField.text
        jsonDict["tags"] = tagViewController.tagsToAdd
        postToServer()
        print(jsonDict)
    }
    
    func postToServer(){
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "23.239.11.5"
        urlComponents.port = 5000
        urlComponents.path = "/microsoft"
        
        // add params
        let nameQuery = URLQueryItem(name: "name", value: jsonDict["name"] as! String)
        let imageQuery = URLQueryItem(name: "image_name", value: jsonDict["image_name"] as! String)
        urlComponents.queryItems = [nameQuery, imageQuery]
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print(string)
            let jsonDataQuery = URLQueryItem(name: "json_data", value: string as! String)
            urlComponents.queryItems = [nameQuery, imageQuery, jsonDataQuery]
        }catch{
            print("Failed conversion to json")
        }
        
        
        let url  = urlComponents.url
        print(url)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = ""
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    @IBAction func exitButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
}
