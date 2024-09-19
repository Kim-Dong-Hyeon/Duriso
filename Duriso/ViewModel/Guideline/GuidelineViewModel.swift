//
//  GuidelineViewModel.swift
//  Duriso
//
//  Created by 신상규 on 9/3/24.
//

import Foundation
import UIKit

import Alamofire
import RxCocoa
import RxSwift

class GuidelineViewModel {
  let title: PublishRelay<String> = PublishRelay()
  let messageContent: PublishRelay<String> = PublishRelay()
  
  private let disposeBag = DisposeBag()
  private let guidelineNetwork = GuidelineNetWork()
  
  private var currentMaxId: Int?
  private var isFetching = false
  private var recentMessages: [String] = []
  
  func fetchData() {
    guard !isFetching else { return }
    isFetching = true
    
    let pageNo = 1
    let numOfRows = 30
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMdd"
    let todayDate = dateFormatter.string(from: Date())
    
    fetchPage(pageNo: pageNo, numOfRows: numOfRows, crtDt: todayDate, rgnNm: "")
  }
  
  private func fetchPage(pageNo: Int, numOfRows: Int, crtDt: String, rgnNm: String) {
    guidelineNetwork.fetchGuidelineData(pageNo: pageNo, numOfRows: numOfRows, crtDt: crtDt, rgnNm: rgnNm)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] apiResponse in
        guard let self = self else { return }
        
        if let body = apiResponse.body, !body.isEmpty {
          // 최대치의 sn 값을 찾음
          if let maxItem = body.max(by: { ($0.sn ?? 0) < ($1.sn ?? 0) }),
             let maxId = maxItem.sn {
            self.currentMaxId = maxId
            let maxIdInt = maxId
            
            // 최대값에서부터 -4까지의 메시지를 필터링
            self.recentMessages = body
              .compactMap { item -> (Int, String)? in
                guard let snInt = item.sn else { return nil }
                return (snInt, item.msgCn)
              }
              .filter { $0.0 >= maxIdInt - 4 }
              .sorted { $0.0 > $1.0 } // 최신 순서로 정렬
              .prefix(5) // 최대 5개로 제한
              .map { $0.1 } // 메시지 내용만 추출
            
            // 최근 메시지를 화면에 즉시 노출시키고 타이머를 시작
            if let firstMessage = self.recentMessages.first {
              self.messageContent.accept(firstMessage)
            }
            self.startDisplayingMessages()
          }
          
          if body.count == numOfRows {
            self.fetchPage(pageNo: pageNo + 1, numOfRows: numOfRows, crtDt: crtDt, rgnNm: rgnNm)
          } else {
            self.title.accept("Max ID: \(self.currentMaxId ?? 0)")
            self.isFetching = false
          }
        } else {
          self.title.accept("No Data")
          self.isFetching = false
        }
        
      }, onError: { [weak self] error in
        guard let self = self else { return }
        print("Error: \(error.localizedDescription)")
        self.title.accept("Failed to Load Data")
        self.messageContent.accept("N/A")
        self.isFetching = false
      })
      .disposed(by: disposeBag)
  }
  
  private func startDisplayingMessages() {
    var messageIndex = 0
    Observable<Int>.interval(.seconds(2), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        if self.recentMessages.isEmpty {
          self.messageContent.accept("N/A")
        } else {
          self.messageContent.accept(self.recentMessages[messageIndex])
          messageIndex = (messageIndex + 1) % self.recentMessages.count
        }
      })
      .disposed(by: disposeBag)
  }
  
  func getRecentMessages() -> [String] {
    return recentMessages
  }
}
