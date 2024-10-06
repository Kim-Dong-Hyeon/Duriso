//
//  MainTabBarViewController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

import RxCocoa
import RxSwift

/// 메인 탭바 컨트롤러
class MainTabBarViewController: UITabBarController {
  
  // MARK: - Properties
  
  private let viewModel: MainTabBarViewModel
  private lazy var firebaseViewModel = FirebaseDataViewModel()
  private let disposeBag = DisposeBag()
  
  /// 네트워크 온라인 상태에서 사용할 뷰 컨트롤러 배열
  private var onlineViewControllers: [UIViewController] = []
  /// 네트워크 오프라인 상태에서 사용할 뷰 컨트롤러 배열
  private var offlineViewControllers: [UIViewController] = []
  
  // MARK: - Initialization
  
  /// ViewModel을 넘겨받아 초기화
  init(viewModel: MainTabBarViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTaps()
    bindViewModel()
    
    // 백그라운드에서 Firebase 데이터를 가져와 Core Data에 저장
    DispatchQueue.global(qos: .background).async { [weak self] in
      self?.firebaseViewModel.fetchDataFromCoreData()
    }
  }
  
  // MARK: - UI Setup
  /// 이미지 크기를 리사이징하는 함수
  func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
    let rect = CGRect(origin: .zero, size: newSize)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
  }
  
  /// 탭바 아이템 설정
  private func setupTaps() {
    let mapIcon = resizeImage(image: UIImage(named: "MapIcon")!, targetSize: CGSize(width: 24, height: 24))
    let selectedMapIcon = resizeImage(image: UIImage(named: "MapIconSelected")!, targetSize: CGSize(width: 24, height: 24))
    
    let communityIcon = resizeImage(image: UIImage(named: "communityIcon")!, targetSize: CGSize(width: 24, height: 24))
    let selectedCommunityIcon = resizeImage(image: UIImage(named: "communityIconSelected")!, targetSize: CGSize(width: 24, height: 24))
    
    let docsIcon = resizeImage(image: UIImage(named: "DocsIcon")!, targetSize: CGSize(width: 20, height: 24))
    let selectedDocsIcon = resizeImage(image: UIImage(named: "DocsIconSelected")!, targetSize: CGSize(width: 20, height: 24))
    
    let userIcon = resizeImage(image: UIImage(named: "UserIcon")!, targetSize: CGSize(width: 24, height: 24))
    let selectedUserIcon = resizeImage(image: UIImage(named: "UserIconSelected")!, targetSize: CGSize(width: 24, height: 24))
    
    let mapVC = UINavigationController(rootViewController: OnlineViewController())
        mapVC.tabBarItem = UITabBarItem(title: "지도", image: mapIcon.withRenderingMode(.alwaysOriginal), selectedImage: selectedMapIcon.withRenderingMode(.alwaysOriginal))
        mapVC.tabBarItem.tag = 0
        
        let boardVC = UINavigationController(rootViewController: BoardViewController())
        boardVC.tabBarItem = UITabBarItem(title: "게시판", image: communityIcon.withRenderingMode(.alwaysOriginal), selectedImage: selectedCommunityIcon.withRenderingMode(.alwaysOriginal))
        boardVC.tabBarItem.tag = 1
        
        let guidelineVC = UINavigationController(rootViewController: GuidelineViewController())
        guidelineVC.tabBarItem = UITabBarItem(title: "행동요령", image: docsIcon.withRenderingMode(.alwaysOriginal), selectedImage: selectedDocsIcon.withRenderingMode(.alwaysOriginal))
        guidelineVC.tabBarItem.tag = 2
        
        let mypageVC = UINavigationController(rootViewController: MyPageViewController())
        mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: userIcon.withRenderingMode(.alwaysOriginal), selectedImage: selectedUserIcon.withRenderingMode(.alwaysOriginal))
        mypageVC.tabBarItem.tag = 3
    
    let offlineMapVC = UINavigationController(rootViewController: OfflineViewController())
    offlineMapVC.tabBarItem = UITabBarItem(title: "지도", image: mapIcon.withRenderingMode(.alwaysOriginal), tag: 0)
    
    let offlineboardVC = UINavigationController(rootViewController: OfflinePageViewController(viewModel: OfflinePageViewModel(), viewName: "게시판"))
    offlineboardVC.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(systemName: "exclamationmark.triangle.fill"), tag: 1)
    
    let offlinemypageVC = UINavigationController(rootViewController: OfflinePageViewController(viewModel: OfflinePageViewModel(), viewName: "마이페이지"))
    offlinemypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "exclamationmark.triangle.fill"), tag: 3)
    
    let offlineMapDevVC = UINavigationController(rootViewController: OfflineViewController())
    offlineMapDevVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "map.fill"), tag: 4)
    
//    onlineViewControllers = [mapVC, boardVC, guidelineVC, mypageVC, offlineMapDevVC]
//    offlineViewControllers = [offlineMapVC, offlineboardVC, guidelineVC, offlinemypageVC]
    
    onlineViewControllers = [mapVC, boardVC, guidelineVC, mypageVC]
    offlineViewControllers = [offlineMapVC, boardVC, guidelineVC, mypageVC]
    
    setViewControllers(onlineViewControllers, animated: true)
  }
  
  // MARK: - Binding
  
  /// ViewModel과 View를 바인딩
  private func bindViewModel() {
    viewModel.isOnline
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] isOnline in
        self?.updateTaps(isOnline: isOnline)
      })
      .disposed(by: disposeBag)
  }
  
  /// 네트워크 상태에 따라 탭을 업데이트
  private func updateTaps(isOnline: Bool) {
    let controllers = isOnline ? onlineViewControllers : offlineViewControllers
    setViewControllers(controllers, animated: true)
  }
}
