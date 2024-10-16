//
//  GuidelineTableViewModel.swift
//  Duriso
//
//  Created by 신상규 on 8/29/24.
//

import Foundation

import RxSwift

struct GuidelineTableViewModel {
  var items = PublishSubject<[Product]>()
  
  func fetchItem() {
    let products = [
      Product(title: "재난키트 체크리스트"),
      Product(title: "국민행동요령"),
      Product(title: "지진"),
      Product(title: "핵공격"),
      Product(title: "화재"),
      Product(title: "집중호우"),
      Product(title: "태풍"),
      Product(title: "대설"),
      Product(title: "산사태"),
      Product(title: "폭염")
    ]
    
    items.onNext(products)
    items.onCompleted()
  }
}

struct YoutubeData { //썸네일과 유튜브를 묶음
  let thumbnails = PublishSubject<[Thumbnail]>()
  let videos = PublishSubject<[VideoItem]>()
  let combinedData = PublishSubject<[VideoThumbnailItem]>()
  
  func fetchData() {
    let thumbnails = [
      Thumbnail(title: "국민행동요령", image: "Alertcon"),
      Thumbnail(title: "지진", image: "Earthquake"),
      Thumbnail(title: "핵공격", image: "NuclearAttack"),
      Thumbnail(title: "화재", image: "Fire"),
      Thumbnail(title: "집중호우", image: "TorrentialRain"),
      Thumbnail(title: "태풍", image: "Typhoon"),
      Thumbnail(title: "대설", image: "Heavysnow"),
      Thumbnail(title: "산사태", image: "Landslide"),
      Thumbnail(title: "폭염", image: "HeatWave")
    ]
    
    let videoItems = [
      VideoItem(title: "국민행동요령", url: URL(string: "https://www.youtube.com/watch?v=DxAQi6wyeeY")!),
      VideoItem(title: "지진", url: URL(string: "https://www.youtube.com/watch?v=7IAg2V7P89w")!),
      VideoItem(title: "핵공격", url: URL(string: "https://www.youtube.com/watch?v=wiGGYdKHtT0")!),
      VideoItem(title: "화재", url: URL(string: "https://www.youtube.com/watch?v=W6Zr5yo5gls")!),
      VideoItem(title: "집중호우", url: URL(string: "https://www.youtube.com/watch?v=3ZXF4TAB9lc")!),
      VideoItem(title: "태풍", url: URL(string: "https://www.youtube.com/watch?v=F5vugtauQT8")!),
      VideoItem(title: "대설", url: URL(string: "https://www.youtube.com/watch?v=4RTKST09z9w")!),
      VideoItem(title: "산사태", url: URL(string: "https://www.youtube.com/watch?v=XTwjVTq64a0")!),
      VideoItem(title: "폭염", url: URL(string: "https://www.youtube.com/watch?v=yXQeLH2QAAs")!)
    ]
    
    // 썸네일과 비디오를 조합하여 새로운 데이터 생성
    let combinedData = zip(thumbnails, videoItems).map { VideoThumbnailItem(thumbnail: $0, videoItem: $1) }
    
    self.thumbnails.onNext(thumbnails)
    self.videos.onNext(videoItems)
    self.combinedData.onNext(combinedData)
  }
}
