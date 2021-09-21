//
//  AppDelegate.swift
//  calc
//
//  Created by Nesiolovsky on 07.11.2020.
//  Copyright © 2020 Nesiolovsky. All rights reserved.
//
// lol

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      let tabBarController = UITabBarController()
      let navigationController = UINavigationController()
      let viewController = ViewController()
      let historyTableViewController = HistoryTableViewController()
      tabBarController.setViewControllers([navigationController, historyTableViewController], animated: true)
      
      navigationController.viewControllers = [viewController]
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.rootViewController = tabBarController
      window?.makeKeyAndVisible()
      return true
    }
}

