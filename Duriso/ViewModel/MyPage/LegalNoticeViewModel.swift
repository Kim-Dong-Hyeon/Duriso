//
//  LegalNoticeViewModel.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/3/24.
//

import Foundation

import RxSwift

class LegalNoticeViewModel {
  var items: Observable<[LegalNoticeModel]>
  
  init() {
    self.items = Observable.just([])
    loadInitialData()
  }
  
  private func loadInitialData() {
    let notices = [
      LegalNoticeModel(title: "서비스 이용약관",
                  content: loadContent(for: "notice1") ?? " "),
      LegalNoticeModel(title: "개인정보 처리방침",
                  content: loadContent(for: "notice2") ?? " "),
      LegalNoticeModel(title: "위치기반 서비스 이용약관",
                  content: loadContent(for: "notice3") ?? " ")
    ]
    self.items = Observable.just(notices)
  }
  
  private func loadContent(for title: String) -> String? {
    guard let path = Bundle.main.path(forResource: title, ofType: "txt"),
          let content = try? String(contentsOfFile: path) else {
      return nil
    }
    return content
  }
}
