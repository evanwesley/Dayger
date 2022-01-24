//
//  SceneDelegate.swift
//  dayger
//
//  Created by Evan Wesley on 12/29/20.
//

import UIKit
import SCSDKLoginKit
import Firebase


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var url : String = ""
    var event : String = ""
    var urlType : String = "" //going to be used later

    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let userActivity = connectionOptions.userActivities.first(where: { $0.webpageURL != nil }) else { return }
                print("url: \(userActivity.webpageURL!)")
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
         //I can add functions to verify that urls are unique and not created outside the app
        
        
        let incomingURL = userActivity.webpageURL
        
        print("url: \(incomingURL!)")
       
        let type = incomingURL!.pathComponents[1] //link should say invitation
        let eventID = incomingURL!.pathComponents[2] //from the event
         
        print("This is the event ID: \(eventID)")
        print("This is the link type: \(type)")
       
        url = incomingURL!.absoluteString
        event = eventID 
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "invitationVC") as! invitationViewController
        destinationViewController.incomingURL = "\(incomingURL!)"
        pushViewController()
        
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>){
        
    }
    func handleURL(_ url: URL) {
      guard url.pathComponents.count >= 3 else { return }

      let type = url.pathComponents[1] //link should say invitation
      let eventID = url.pathComponents[2] //from the event
        print(eventID)
        print(type)
        
        
       
        
    }
    func pushHomeVC (){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! homeViewController

        // Then push that view controller onto the navigation stack
        let rootViewController = self.window!.rootViewController
        
        rootViewController?.present(viewController, animated: true)
        
        
    }
    
    
    func navigateToInvitationViewController () {
        
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homePage = mainStoryboard.instantiateViewController(withIdentifier: "invitationVC") as! invitationViewController
 
        self.window?.rootViewController = homePage
        
    }
    func pushViewController () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: invitationViewController = storyboard.instantiateViewController(withIdentifier: "invitationVC") as! invitationViewController

        // Then push that view controller onto the navigation stack
        let rootViewController = self.window!.rootViewController
        
        rootViewController?.present(viewController, animated: true)
        

    }
    


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
   
}

