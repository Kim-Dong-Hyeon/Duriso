//
//  GuidelineModel.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import Foundation

// 유튜브 & 썸네일
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

struct Product {
  let title: String
}

struct ApiResponse: Decodable {
  let body: [Item]?
  
  struct Item: Decodable {
    let sn: Int?
    let crtDt: String
    let msgCn: String
    let rcptnRgnNm: String
    let regYmd: String
    
    enum CodingKeys: String, CodingKey {
      case sn = "SN"
      case crtDt = "CRT_DT"
      case msgCn = "MSG_CN"
      case rcptnRgnNm = "RCPTN_RGN_NM"
      case regYmd = "REG_YMD"
    }
  }
}
