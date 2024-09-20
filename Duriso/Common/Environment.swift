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
    static let disasterApiKey = "DISASTER_API_KEY"
    static let shelterApiKey = "SHELTER_API_KEY"
    static let aedApiKey = "AED_API_KEY"
    static let mapTilerApiKey = "MAPTILER_API_KEY"
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
  
  static let disasterApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.disasterApiKey] as? String else {
      fatalError("DISASTER_API_KEY not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
  
  static let shelterApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.shelterApiKey] as? String else {
      fatalError("SHELTER_API_KEY not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
  
  static let aedApiKey: String = {
    guard let apiKey = Environment.infoDictionary[Keys.aedApiKey] as? String else {
      fatalError("aedApiKey not set in Info.plist or xcconfig")
    }
    return apiKey
  }()
  
  static let mapTilerApiKey: String = {
    guard let mapTilerKey = Bundle.main.object(forInfoDictionaryKey: "MAPTILER_API_KEY") as? String else {
      fatalError("Failed to read MapTiler key from info.plist")
    }
    if mapTilerKey.compare("placeholder", options: .caseInsensitive) == .orderedSame {
      fatalError("Please enter correct MapTiler key in info.plist[MAPTILER_API_KEY] property")
    }
    return mapTilerKey
  }()
  
}
