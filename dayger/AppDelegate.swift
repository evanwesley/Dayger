//
//  AppDelegate.swift
//  dayger
//
//  Created by Evan Wesley on 12/29/20.
//

import UIKit
import Firebase
import SCSDKLoginKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ app: UIApplication,
                        open url: URL,
                        options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           return SCSDKLoginClient.application(app, open: url, options: options)
       }
     @available (iOS 13, *)
      func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          for urlContext in URLContexts {
              let options: [UIApplication.OpenURLOptionsKey : Any] = [
                  .openInPlace: urlContext.options.openInPlace,
                  .sourceApplication: urlContext.options.sourceApplication!,
                  .annotation: urlContext.options.annotation!
              ]
       SCSDKLoginClient.application(UIApplication.shared, open: urlContext.url, options: options)
          }
     }

}
