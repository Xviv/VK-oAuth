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
    
    var user = [User]()
    var friends = [Friends]()
    
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        authorize()
        //Еще костыль
        checkSessionStateAndPerformSegue(time: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getCurrentUserInfo()
        getFriend()
        checkSessionStateAndPerformSegue(time: 1)
        
    }
    
    func checkSessionStateAndPerformSegue(time: Double) {
        if VK.sessions.default.state == .authorized {
            print("Session is authorized")
            //Знаю, что это костыль :)
            DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            })
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
        }
        )
    }
    
    func getCurrentUserInfo() {
        VK.API.Users.get(.empty)
            .onSuccess {
                let response = try JSONSerialization.jsonObject(with: $0)
                let jsonResponse = JSON(response)
                print(jsonResponse)
                self.parseJSON(json: jsonResponse, parseType: .currentUser)
            }
            .onError({ (error) in
                print(error)
            })
            .send()
    }
    
    func getFriend() {
        VK.API.Friends.get([
            .count : "5",
            .fields : "name"
            ])
            .onSuccess {
                let response = try JSONSerialization.jsonObject(with: $0)
                let jsonResponse = JSON(response)
                print(jsonResponse)
                self.parseJSON(json: jsonResponse, parseType: .friend)
            }
            .onError({ (error) in
                print(error)
            })
        .send()
        
    }
    
    func parseJSON(json: JSON, parseType: UserType) {
        switch parseType {
        case .currentUser:
            guard let name = json[0]["first_name"].string else {fatalError("userInfo Parse error")}
            guard let lastname = json[0]["last_name"].string else {fatalError("userInfo Parse error")}
            let userInfo = User(name: name, lastName: lastname)
            user.append(userInfo)
        case .friend:
            var i = 0
            for _ in json["items"] {
                guard let name = json["items"][i]["first_name"].string else {fatalError("userInfo Parse error")}
                guard let lastname = json["items"][i]["last_name"].string else {fatalError("userInfo Parse error")}
                let friendInfo = Friends(name: name, lastName: lastname)
                friends.append(friendInfo)
                i += 1
            }
            
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let VC = segue.destination as! UserInfoController
            
            VC.user = user
            VC.friend = friends
            
        }
    }


}

