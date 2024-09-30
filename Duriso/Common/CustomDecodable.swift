//
//  CustomDecodable.swift
//  Duriso
//
//  Created by 김동현 on 9/28/24.
//

import Foundation

import Foundation

enum CustomDecodable: Codable {
  case string(String)
  case int(Int)
  case int16(Int16)
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let codingPath = container.codingPath
    let attributePath = codingPath.map { $0.stringValue }.joined(separator: ".")
    
    if let intValue = try? container.decode(Int.self) {
      self = .int(intValue)
      return
    }
    
    if let int16Value = try? container.decode(Int16.self) {
      self = .int16(int16Value)
      return
    }
    
    if let stringValue = try? container.decode(String.self) {
      self = .string(stringValue)
      return
    }
    
    // 인덱스 정보를 추출하여 디버그 출력 (오류 발생 시)
    if let index = codingPath.first(where: { $0.intValue != nil })?.intValue {
      print("디코딩 오류 발생 - Index \(index). Attribute: \(attributePath)")
    } else {
      print("디코딩 오류 발생 - Attribute: \(attributePath)")
    }
    
    throw DecodingError.typeMismatch(CustomDecodable.self, DecodingError.Context(codingPath: codingPath, debugDescription: "Expected to decode String or Int at \(attributePath)"))
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    
    switch self {
    case .string(let stringValue):
      try container.encode(stringValue)
    case .int(let intValue):
      try container.encode(intValue)
    case .int16(let int16Value):
      try container.encode(int16Value)
    }
  }
  
  var stringValue: String {
    switch self {
    case .string(let value):
      return value
    case .int(let value):
      return String(value)
    case .int16(let value):
      return String(value)
    }
  }
  
  var intValue: Int? {
    switch self {
    case .string(let value):
      return Int(value)
    case .int(let value):
      return value
    case .int16(let value):
      return Int(value)
    }
  }
  
  var int16Value: Int16? {
    switch self {
    case .string(let value):
      return Int16(value)
    case .int(let value):
      return Int16(value)
    case .int16(let value):
      return value
    }
  }
}
