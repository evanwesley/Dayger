//
//  AppDelegate.swift
//  dayger
//
//  Created by Evan Wesley on 12/29/20.
//

import UIKit
import Firebase
import FirebaseDynamicLinks
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin" )
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else  {
                return
            }
            print("successful in registering for APNS")
        }
        
        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
        }
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
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      
        if let incomingURL = userActivity.webpageURL {
            print ("Incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) {[weak self](dynamicLink, error) in
                guard error == nil else {
                    print("Found Error \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self?.handleIncomingDynamicLink(dynamicLink)
                }
            }
            return linkHandled
        }
        return false
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have received a URL through a custom URL Scheme \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            
            self.handleIncomingDynamicLink(dynamicLink)
            return true
            
        } else {
            //Maybe handle google sign in
            return false
        }
    }
    func handleIncomingDynamicLink (_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("No URL Detected")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
        //We can parse the url and send the data here
    }
    
    func setupNavigationBar () {
        
        
      
    }
    
}
