//
//  CopyrightViewModel.swift
//  Duriso
//
//  Created by 김동현 on 9/20/24.
//

import Foundation

import RxSwift

class CopyrightViewModel {
  var items: Observable<[Copyright]>
  
  init() {
    self.items = Observable.just([])
    loadInitialData()
  }
  
  private func loadInitialData() {
    let copyrights = [
      Copyright(title: "notoSans",
                  content: loadContent(for: "notoSans") ?? " "),
      Copyright(title: "maplibre",
                  content: loadContent(for: "maplibre") ?? " "),
      Copyright(title: "API",
                  content: loadContent(for: "api") ?? " "),
      Copyright(title: "이미지, 영상, 문서",
                  content: loadContent(for: "imagedocument") ?? " ")
    ]
    self.items = Observable.just(copyrights)
  }
  
  private func loadContent(for title: String) -> String? {
    guard let path = Bundle.main.path(forResource: title, ofType: "txt"),
          let content = try? String(contentsOfFile: path) else {
      return nil
    }
    return content
  }
}
