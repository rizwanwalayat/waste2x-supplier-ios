//
//  AppDelegate.swift
//  Doro
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import Firebase
import netfox
import FirebaseMessaging
import GoogleMaps
import GooglePlaces

let gcmMessageIDKey = "gcm.message_id"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var weaterCalldelegate:WeatherCallDelegate?
    var locationManager = CLLocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NFX.sharedInstance().start()
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
        Messaging.messaging().delegate = self
        pushNotification(applicationVariable: application, launchOptionsVariable: launchOptions)
        if DataManager.shared.getUser() == nil
        {
            Utility.loginRootViewController()
            
            
        }
        else
        {
            Utility.homeViewController()
        }
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        initializeLocationManager()
        return true
    }
    // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if userActivity.webpageURL != nil {
//                let stripeHandled = StripeAPI.handleURLCallback(with: url)
//
//                if stripeHandled {
//                    return true
//                } else {
//                    // This was not a stripe url, do whatever url handling your app
//                    // normally does, if any.
//                }
            }

        }
        return false
    }
    
    
    //MARK: - Locationmanager
    
    private func initializeLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 50
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }else{
            print("Internet Error")
        }
    }

    // [REGISTRATION push_notifications]
    func pushNotification(applicationVariable:UIApplication,launchOptionsVariable:[UIApplication.LaunchOptionsKey : Any]?){
        if #available(iOS 10.0, *) {
                  // For iOS 10 display notification (sent via APNS)
                  UNUserNotificationCenter.current().delegate = self

                  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                  UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in
                        
                    })
                } else {
                  let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    applicationVariable.registerUserNotificationSettings(settings)
                }
        applicationVariable.registerForRemoteNotifications()
                let notification = launchOptionsVariable?[UIApplication.LaunchOptionsKey.remoteNotification]
                if notification != nil {
                    Global.shared.didRecievedNotiFication = true
                }
                // [END register_for_notifications]
    }
    // [START receive_message]
//      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message IDwithout completion: \(messageID)")
//        }
//        // Print full message.
//        print(userInfo)
//      }
//      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("recieved")
//        if let messageID = userInfo[gcmMessageIDKey] {
//          print("Message ID: didreceveremote\(messageID)")
//        }
//        print(userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//
//      }
      // [END receive_message]
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
      }

      // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
      // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
      // the FCM registration token.
      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        // With swizzling disabled you must set the APNs token here.
        // Messaging.messaging().apnsToken = deviceToken
      }


}





//MARK: - UNUserNotificationCenterDelegate
//@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo
    print(userInfo)
    if (userInfo["id"] as? String) != nil {
        print(userInfo)
    }
    completionHandler([[.alert, .sound,.badge]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    print(userInfo)
    if let id = userInfo["id"] as? String {
        print(id)
        let n = window
        self.window = n
        window?.makeKeyAndVisible()
    }
    completionHandler()
  }
    
}

extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmTokenVariable = fcmToken {
            Global.shared.fireBaseToken = fcmTokenVariable
            FireBaseVariables.fireBaseToken = fcmTokenVariable
            print("Firebase registration token: \(fcmTokenVariable)")
        }
    
    }
    
}
    
// MARK: - Location delegate
extension AppDelegate:CLLocationManagerDelegate {

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last
        {
            
            Global.shared.location = location
            Global.shared.current_lat = location.coordinate.latitude
            Global.shared.current_lng = location.coordinate.longitude
            weatherAPI()
            print(location,Global.shared.current_lat,Global.shared.current_lng)
            
            
        }
        locationManager.stopUpdatingLocation()
    }
    func weatherAPI(){
        
        WeatherAPI.WeatherAPICall{ result, error, statusCode,message in
            if statusCode == true{
                self.weaterCalldelegate?.Weather()
            }
        }
    }
}
