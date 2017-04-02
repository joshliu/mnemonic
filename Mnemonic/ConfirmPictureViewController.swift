//
//  ConfirmPictureViewController.swift
//  Mnemonic
//
//  Created by Avery Lamp on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit

class ConfirmPictureViewController: UIViewController {

    @IBOutlet weak var image0: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet var images: [UIImageView]!
    
    var jsonDict = Dictionary<String, Any>()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        images.forEach{
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowRadius = 5
            $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        }
        imageSelected(UIButton())
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ConfirmPictureViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard(){
        nameTextField.resignFirstResponder()
        
    }
    
    @IBAction func imageSelected(_ sender: UIButton) {
        images.forEach {
            if $0.tag == sender.tag{
                $0.layer.borderWidth = 5.0
                $0.layer.borderColor = UIColor(red: 1.000, green: 0.831, blue: 0.557, alpha: 1.00).cgColor
            }else{
                $0.layer.borderWidth = 0.0
            }
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        jsonDict["name"] = nameTextField.text
        var tag = 0
        images.forEach{
            if $0.layer.borderWidth != 0.0{
                tag = $0.tag
            }
        }
        jsonDict["image_name"] = "image\(tag).jpg"
        let confirmTagsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmTagsVC") as! ConfirmTextViewController
        confirmTagsVC.jsonDict = self.jsonDict
        print(jsonDict)
        self.navigationController?.pushViewController(confirmTagsVC, animated: true)
    }
    
}
