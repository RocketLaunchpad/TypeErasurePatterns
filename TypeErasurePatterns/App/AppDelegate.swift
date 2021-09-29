//
//  AppDelegate.swift
//  TypeErasurePatterns
//
//  Created by Paul Calnan on 9/29/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let vc = UIViewController()
        vc.view.backgroundColor = .darkGray

        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        return true
    }
}
