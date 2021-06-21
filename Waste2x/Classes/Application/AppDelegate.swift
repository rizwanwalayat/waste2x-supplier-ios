//
//  AppDelegate.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import Firebase
//import netfox
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
//        NFX.sharedInstance().start()
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        // [END register_for_notifications]
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
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)
      }

      // [START receive_message]
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                       fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
      }
      func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
      }
      func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
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



}


extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmTokenVariable = fcmToken {
            Global.shared.fireBaseToken = fcmTokenVariable
            FireBaseVariables.fireBaseToken = fcmTokenVariable
            print("Firebase registration token: \(fcmTokenVariable)")
        }
    
    }
}
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    print(userInfo)

    completionHandler()
  }
}
// [END ios_10_message_handling]
    
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
