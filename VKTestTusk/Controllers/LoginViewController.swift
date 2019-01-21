//
//  ViewController.swift
//  VKTestTusk
//
//  Created by Dan on 21/01/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        authorize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if VK.sessions.default.state == .authorized {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    
    func authorize() {
        VK.sessions.default.logIn(
            onSuccess: { info in
                print("Success authorize with", info)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
        },
            onError: { error in
                print("Authorize failed with", error)
        })
    }
}

