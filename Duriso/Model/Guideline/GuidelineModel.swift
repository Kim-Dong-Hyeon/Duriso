//
//  GuidelineModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation
import RxRelay

struct GuidelineModel {
  let title: String
  let url: URL
}

struct Product {
  let imageName: String
  let title: String
}

struct VideoItem {
  let title: String
  let url: URL
}

struct Thumbnail {
  let title: String
  let image: String
}

struct VideoThumbnailItem {
  let thumbnail: Thumbnail
  let videoItem: VideoItem
}

struct ApiResponse: Decodable {
  let header: Header
  let numOfRows: Int
  let pageNo: Int
  let totalCount: Int
  let body: [Item]
  
  struct Header: Decodable {
    let resultMsg: String
    let resultCode: String
    let errorMsg: String?
  }
  
  struct Item: Decodable {
    let crtDt: String
    let ynaWrtrNm: String
    let ynaCn: String
    let ynaYmd: String
    let ynaTtl: String
    let ynaNo: Int
    
    enum CodingKeys: String, CodingKey {
      case crtDt = "CRT_DT"
      case ynaWrtrNm = "YNA_WRTR_NM"
      case ynaCn = "YNA_CN"
      case ynaYmd = "YNA_YMD"
      case ynaTtl = "YNA_TTL"
      case ynaNo = "YNA_NO"
    }
  }
}
