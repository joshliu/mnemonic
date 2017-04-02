//
//  NavigationController.swift
//  Mnemonic
//
//  Created by Joshua Liu on 4/1/17.
//  Copyright © 2017 Joshua Liu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var timer = Timer()
    var state = String()
    var prevState = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(tick), userInfo: nil, repeats: true)
        
        state = "DEFAULT"
        prevState = "DEFAULT"
        
        // Do any additional setup after loading the view.
    }

    func tick() {
        print("tick")
        
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "23.239.11.5"
        urlComponents.port = 5000
        urlComponents.path = "/state"

        
        let url  = urlComponents.url
        print(url!)
        
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration:URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) { (data, resp, err) in
            // print(err!)
            let str = String(data: data!, encoding: .utf8)
            print(str!)
            self.state = str!
            
            
        }
        
        task.resume()
        
        if (state != prevState) {
            // state changed. figure out what it changed to
            if (state == "LISTENING") {
                // present listening view controller
                let listeningVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListeningVC") as! ListeningViewController
                self.pushViewController(listeningVC, animated: true)
            } else if (state == "DONE") {
                // present confirm view controller
            } else if (state == "FOUND") {
                // present profile view controller
            } else {
                // default, root view controller
                
            }
        } else {
            // test post pls ignore
        }
        
        prevState = state

    }
    
}
