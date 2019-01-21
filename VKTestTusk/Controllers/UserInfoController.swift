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

class UserInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var user: [User]?
    var friend: [Friends]?
    
    @IBOutlet weak var currentUserNamelabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logoutButtonTouchUpInside(_ sender: Any) {
        VK.sessions.default.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = user {
            print(currentUser)
            currentUserNamelabel.text = currentUser[0].name + " " + currentUser[0].lastName
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - tableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Friends:"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let friends = friend {
            return friends.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let friendInfo = friend {
            let friends = friendInfo[indexPath.row]
            //getting first and last name in one label with space
            cell.textLabel?.text = friends.name + " " + friends.lastName
        } else {
            cell.textLabel?.text = "No friends"
        }
        
        return cell
    }
}
