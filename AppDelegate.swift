//
//  AppDelegate.swift
//  Swift-SampleApp
//
//  Created by Dustin Allen on 2/3/20.
//  Copyright © 2020 Gimbal. All rights reserved.
//

import UIKit
import Gimbal
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // To get started with an API key, go to https://manager.gimbal.com/
        #warning ("Insert your Gimbal Application API key below in order to see this sample application work")
        Gimbal.setAPIKey("69f9a033-fd34-4454-b213-65a7230873ad", options: nil)
        
        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] {
            processRemoteNotification(userInfo: remoteNotification as! [String : Any])
        }
        
        if let localNotification = launchOptions?[UIApplication.LaunchOptionsKey.localNotification] {
            processLocalNotification(notification: localNotification as! UILocalNotification)
        }
        
        
        return true
    }
    
    //MARK: Remote Notification Support
    func registerForNotifications(application: UIApplication) {
         let app = UIApplication.shared

         if #available(iOS 10.0, *) {
             UNUserNotificationCenter.current().delegate = self

             let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
             UNUserNotificationCenter.current().requestAuthorization(
                 options: authOptions,
                 completionHandler: {_, _ in })
         } else {
             let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
             app.registerUserNotificationSettings(settings)
         }

         app.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        registerForNotifications(application: UIApplication.shared)
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Gimbal.setPushDeviceToken(deviceToken)

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Registration for remote notifications failed with error ", error.localizedDescription)
    }

    //MARK: UISceneSession Lifecycle

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
    
    //MARK: GMBLCommunicationManager Delegate Callbacks for legacy notifications
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // The state call seems to be missing in the conversion to Swift, will need to look more into that
        let state = application.applicationState
        
        processLocalNotification(notification: notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        processNotificationResponse(response: response)
        completionHandler()
    }
    
    //MARK: GMBLCommunicationManager Delegate Callbacks for User Notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
    }
    
    //MARK: Notification Helper Methods
    func processRemoteNotification(userInfo: [String:Any]) {
        if let communcation = GMBLCommunicationManager.communication(forRemoteNotification: userInfo) {
            storeCommunication(communication: communcation)
        }
    }
    
    func processNotificationResponse(response: UNNotificationResponse) {
        if let communcation: GMBLCommunication = GMBLCommunicationManager.communication(for: response) {
            storeCommunication(communication: communcation)
        }
    }
    
    func processLocalNotification(notification: UILocalNotification) {
        if let communcation: GMBLCommunication = GMBLCommunicationManager.communication(for: notification) {
            storeCommunication(communication: communcation)
        }
    }
    
    // Not as sure about the casting of this in Objective-C -> Swift, will need to verify
    func storeCommunication(communication: GMBLCommunication) {
        let nv = UINavigationController()
        
        if nv.topViewController is ViewController {
            let vc = ViewController()
            vc.addCommuncation(communication: communication)
            
        }
    }

}

