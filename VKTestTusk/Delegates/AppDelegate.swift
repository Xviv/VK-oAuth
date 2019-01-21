//
//  AppDelegate.swift
//  VKTestTusk
//
//  Created by Dan on 21/01/2019.
//  Copyright © 2019 Daniil. All rights reserved.
//

import UIKit
import SwiftyVK

var vkDelegateReference : SwiftyVKDelegate?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        vkDelegateReference = VKDelegate()
        return true
    }

    @available(iOS 9.0, *)
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        ) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }
    
    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
        ) -> Bool {
        VK.handle(url: url, sourceApplication: sourceApplication)
        return true
    }
}

