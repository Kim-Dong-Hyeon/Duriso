//
//  CSVManager.swift
//  Duriso
//
//  Created by 김동현 on 9/18/24.
//

import Foundation

class CSVManager {
  static func readCSV(fileName: String, encoding: String.Encoding = .utf8) -> [[String: String]] {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "csv") else {
      print("CSV file not found: \(fileName)")
      return []
    }
    
    do {
      let content = try String(contentsOfFile: path, encoding: encoding)
      var rows = content.components(separatedBy: .newlines)
      
      // Remove BOM if present
      var headers = rows.removeFirst().components(separatedBy: ",")
      if let firstHeader = headers.first, firstHeader.hasPrefix("\u{FEFF}") {
        headers[0] = String(firstHeader.dropFirst())
      }
      
      print("CSV headers for \(fileName): \(headers)")
      
      let result = rows.compactMap { row -> [String: String]? in
        var columns = [String]()
        var currentColumn = ""
        var inQuotes = false
        
        for char in row {
          if char == "\"" {
            inQuotes.toggle()
          } else if char == "," && !inQuotes {
            columns.append(currentColumn.trimmingCharacters(in: .whitespaces))
            currentColumn = ""
          } else {
            currentColumn.append(char)
          }
        }
        columns.append(currentColumn.trimmingCharacters(in: .whitespaces))
        
        var dict = [String: String]()
        for (index, header) in headers.enumerated() {
          if index < columns.count {
            dict[header] = columns[index]
          }
        }
        return dict.isEmpty ? nil : dict
      }
      
      print("CSV rows parsed for \(fileName): \(result.count)")
      return result
    } catch {
      print("Error reading CSV file \(fileName): \(error)")
      return []
    }
  }
}
