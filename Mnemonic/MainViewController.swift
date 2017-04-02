//
//  MainViewController.swift
//  Mnemonic
//
//  Created by Avery Lamp on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!

    var imageData = [UIImage]()
    var personData = [Dictionary<String, Any>]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var data = Dictionary<String, Any>()
        data["name"] = "Avery Lamp"
        data["calendar"] = "Met on April 1st"
        data["location"] = "Princeton, New Jersey"
        personData.append(data)
        data["name"] = "Arlene Siswanto"
        data["calendar"] = "Met on April 2nd"
        data["location"] = "Princeton, New Jersey"
        personData.append(data)
        data["name"] = "Joshua Liu"
        data["calendar"] = "Met on April 3rd"
        data["location"] = "UWaterloo, Canada"
        personData.append(data)
        data["name"] = "Avery Lamp"
        data["calendar"] = "Met on April 1st"
        data["location"] = "Princeton, New Jersey"
        personData.append(data)
        data["name"] = "Arlene Siswanto"
        data["calendar"] = "Met on April 2nd"
        data["location"] = "Princeton, New Jersey"
        personData.append(data)
        data["name"] = "Joshua Liu"
        data["calendar"] = "Met on April 3rd"
        data["location"] = "UWaterloo, Canada"
        personData.append(data)
        
        imageData = [UIImage(named: "tempProPic")!, UIImage(named: "tempProPic")!, UIImage(named: "tempProPic")!, UIImage(named: "tempProPic")!, UIImage(named: "tempProPic")!, UIImage(named: "tempProPic")!]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        triggerEditVC()
    }
    
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        profileVC.view.frame = self.view.frame
        profileVC.nameLabel.text = personData[index]["name"] as? String
        profileVC.calendarLabel.text = personData[index]["calendar"] as? String
        profileVC.locationLabel.text = personData[index]["location"] as? String
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        cell.nameLabel.text = personData[indexPath.row]["name"] as? String
        cell.calendarLabel.text = personData[indexPath.row]["calendar"] as? String
        cell.locationLabel.text = personData[indexPath.row]["location"] as? String
        if indexPath.row < imageData.count{
            let image = imageData[indexPath.row]
            cell.profileImage.image = image
            cell.profileImage.layer.masksToBounds = true
            
        }
        
        return cell
    }
    
    func triggerEditVC(){
        
        var images = [UIImage]()
        Alamofire.request("http://23.239.11.5:5000/recent_image/image0.jpg").responseData { (data) in
            let image = UIImage(data: data.data!)
            images.append(image!)
            Alamofire.request("http://23.239.11.5:5000/recent_image/image1.jpg").responseData { (data) in
                let image = UIImage(data: data.data!)
                images.append(image!)
                Alamofire.request("http://23.239.11.5:5000/recent_image/image2.jpg").responseData { (data) in
                    let image = UIImage(data: data.data!)
                    images.append(image!)
                    let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConfirmPictureVC") as! ConfirmPictureViewController
                    editVC.inputImages = images
                    self.navigationController?.pushViewController(editVC, animated: true)
                    
                }
            }
            
        }
        
    }
    
    
}
