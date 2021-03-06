//
//  User.swift
//  VKTestTusk
//
//  Created by Dan on 21/01/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import Foundation

enum UserType {
    case currentUser
    case friend
}

class User {
    let name: String
    let lastName: String
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}
