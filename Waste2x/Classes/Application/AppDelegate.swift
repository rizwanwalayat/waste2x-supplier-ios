//
//  AppDelegate.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import ObjectMapper
import Firebase
//import netfox
import FirebaseMessaging
import GoogleMaps
import GooglePlaces
import UserNotifications

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
        GMSAutocompleteViewControllerHandling()
        initializeLocationManager()
        loginToTwillio()
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        loginToTwillio()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        TwillioChatDataModel.shared.shutdown()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        TwillioChatDataModel.shared.shutdown()
    }
    
    // code for load all messages
    func loginToTwillio()
    {
        MessagesDataModel.fetchTwillioAccessToken() { dataResponse, error, success, message  in
            
            if dataResponse != nil {
                
                if let isSuccess = success {
                    
                    if isSuccess {
                        
                        if let token = dataResponse?.result?.access_token {
                            
                            TwillioChatDataModel.shared.loginToTwillio(with: token)
                    
                        }
                    }
                }
                
            }
        }
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
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
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



    func GMSAutocompleteViewControllerHandling()
    {
        // Customize the UI of GMSAutocompleteViewController
        // Set some colors (colorLiteral is convenient)
        let barColor: UIColor =  UIColor.appColor
        let backgroundColor: UIColor =  _ColorLiteralType(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let textColor: UIColor =  _ColorLiteralType(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        // Navigation bar background.
          UINavigationBar.appearance().barTintColor = barColor
          UINavigationBar.appearance().tintColor = UIColor.white
        // Color and font of typed text in the search bar.
          let searchBarTextAttributes = [NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = searchBarTextAttributes as [NSAttributedString.Key : Any]
        // Color of the placeholder text in the search bar prior to text entry
          let placeholderAttributes = [NSAttributedString.Key.foregroundColor: backgroundColor, NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 15)]
        // Color of the default search text.
          let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes as [NSAttributedString.Key : Any])
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
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
    NotificationCenter.default.post(name: Notification.Name("point"), object: nil)
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
    NotificationCenter.default.post(name: Notification.Name("notification"), object: nil)
    NotificationCenter.default.post(name: Notification.Name("point"), object: nil)
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
