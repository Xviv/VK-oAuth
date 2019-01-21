//
//  UserInfoController.swift
//  VKTestTusk
//
//  Created by Dan on 21/01/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import Foundation
import UIKit
import SwiftyVK
import SwiftyJSON

class UserInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user = [User]()
    var friends = [Friends]()
    
    @IBOutlet weak var currentUserNamelabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logoutButtonTouchUpInside(_ sender: Any) {
        VK.sessions.default.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCurrentUserInfo()
        getFriend()
        print("Friends: \(friends)")
    }
    
    func getCurrentUserInfo() {
        VK.API.Users.get(.empty)
            .onSuccess {
                let response = try JSONSerialization.jsonObject(with: $0)
                let jsonResponse = JSON(response)
                print(jsonResponse)
                self.parseJSON(json: jsonResponse, parseType: .currentUser)
                DispatchQueue.main.async {
                    self.currentUserNamelabel.text = self.user[0].name + " " + self.user[0].lastName
                }
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        default:
            break
        }
    }
    
    //MARK: - tableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends:"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print(friends)
        let friend = friends[indexPath.row]
            //getting first and last name in one label with space
        cell.textLabel?.text = friend.name + " " + friend.lastName
        
        
        return cell
    }
}
