//
//  AppDelegate.swift
//  EmployeeManagement
//
//  Created by Deblina Das on 04/05/17.
//  Copyright © 2017 Deblina Das. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = EmployeeListTableViewController.viewController()
        window!.makeKeyAndVisible()
        return true
    }
}

