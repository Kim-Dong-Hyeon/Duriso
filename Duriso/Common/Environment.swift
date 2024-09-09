//
//  Environment.swift
//  Duriso
//
//  Created by 김동현 on 9/4/24.
//

import Foundation

public enum Environment {
  enum Keys {
    static let kakaoMapApiKey = "KAKAO_MAP_API_KEY"
    static let kakaoDevApiKey = "KAKAO_DEV_API_KEY"
    static let newsApiKey = "NEWS_API_KEY"
    static let shelterApiKey = "SHELTER_API_KEY"
  }
  
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("plist file not found")
    }
    return dict
  }()
  
  static let kakaoMapApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.kakaoMapApiKey] as? String else {
      fatalError("KAKAO_MAP_API_KEY not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
  
  static let kakaoDevApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.kakaoDevApiKey] as? String else {
      fatalError("KAKAO_DEV_API_KEY not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
  
  static let newsApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.newsApiKey] as? String else {
      fatalError("NEWS_API_KEY not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
  
  static let shelterApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.shelterApiKey] as? String else {
      fatalError("SHELTER_API_KEY not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
}
