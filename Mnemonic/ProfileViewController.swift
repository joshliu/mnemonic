//
//  ProfileViewController.swift
//  Mnemonic
//
//  Created by Joshua Liu on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, TagViewControllerDelegate{

    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    var speechTags = [String]()
    
    @IBOutlet weak var exitTextField: UITextField!
    @IBOutlet weak var pushButton: UIButton! {
        didSet {
            pushButton.isEnabled = false
            pushButton.setTitleColor(UIColor.init(red: 255/255, green: 124/255, blue: 165/255, alpha: 1.0), for: UIControlState())
            pushButton.setTitleColor(UIColor.lightGray, for: .disabled)
        }
    }

    let tagLimit = 6
    var tagViewController = TagViewController()
    var alertResponder: SCLAlertViewResponder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagViewController.view = tagView
        tagViewController.delegate = self
        exitTextField.text = "MIT"
        addButton(exitTextField)
        exitTextField.text = "Stuff"
        addButton(exitTextField)
        exitTextField.text = "More Stuff"
        addButton(exitTextField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
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
                    self.view.frame.origin.y += keyboardSize.height
                })
            }
        }
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        let textField = sender as! UITextField
        if ((textField.text?.characters.count)! > 0) {
            pushButton.isEnabled = true
        } else {
            pushButton.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButton(_ sender: Any) {
        if (exitTextField.text != nil  ) {
            
            let noSpacesText = exitTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
            if (noSpacesText == "") {
                return
            }
            tagViewController.addSingleTagView(noSpacesText)
            exitTextField.text = ""
            pushButton.isEnabled = false
            textFieldChanged(exitTextField)
            exitTextField.resignFirstResponder()
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
        textFieldChanged(exitTextField)
        if alertResponder != nil {
            alertResponder.close()
        }
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
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
