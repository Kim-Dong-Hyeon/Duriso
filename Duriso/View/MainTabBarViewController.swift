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
  }
  
  // MARK: - UI Setup
  
  /// 탭바 아이템 설정
  private func setupTaps() {
    let mapVC = UINavigationController(rootViewController: OnlineViewController())
    mapVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "globe"), tag: 0)
    
    let boardVC = UINavigationController(rootViewController: BoardViewController())
    boardVC.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
    
    let guidelineVC = UINavigationController(rootViewController: GuidelineViewController())
    guidelineVC.tabBarItem = UITabBarItem(title: "행동요령", image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
    
    let mypageVC = UINavigationController(rootViewController: MyPageViewController())
    mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.circle"), tag: 3)
    
    let offlineMapVC = UINavigationController(rootViewController: OfflineViewController())
    offlineMapVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "map.fill"), tag: 0)
    
    let offlineboardVC = UINavigationController(rootViewController: OfflinePageViewController(viewModel: OfflinePageViewModel(), viewName: "게시판"))
    offlineboardVC.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(systemName: "exclamationmark.triangle.fill"), tag: 1)
    
    let offlinemypageVC = UINavigationController(rootViewController: OfflinePageViewController(viewModel: OfflinePageViewModel(), viewName: "마이페이지"))
    offlinemypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "exclamationmark.triangle.fill"), tag: 3)
    
    onlineViewControllers = [mapVC, boardVC, guidelineVC, mypageVC]
    
    offlineViewControllers = [offlineMapVC, offlineboardVC, guidelineVC, offlinemypageVC]
    
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
