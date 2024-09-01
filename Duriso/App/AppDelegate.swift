//
//  AppDelegate.swift
//  Duriso
//
//  Created by 김동현 on 8/25/24.
//

import UIKit
import FirebaseCore
import KakaoMapsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = MainTabBarController()
    window?.makeKeyAndVisible()
    
    FirebaseApp.configure()
    
    if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String {
      print("Using Kakao App Key: \(kakaoAppKey)")
      SDKInitializer.InitSDK(appKey: kakaoAppKey)
    } else {
      print("Error: Kakao App Key is missing in Info.plist or xcconfig")
    }
    return true
  }
}

