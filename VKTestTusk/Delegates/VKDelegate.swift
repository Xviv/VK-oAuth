//
//  VKDelegate.swift
//  VKTestTusk
//
//  Created by Dan on 21/01/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import Foundation
import SwiftyVK

class VKDelegate: SwiftyVKDelegate {
    
    let appID = "6827647"
    let scopes: Scopes = [.friends]
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    init() {
        VK.setUp(appId: appID, delegate: self)
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            rootController.present(viewController, animated: true)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        print("token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        print("token removed in session \(sessionId)")
    }
    
}
