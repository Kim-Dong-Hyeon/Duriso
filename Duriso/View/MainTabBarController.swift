//
//  MainTabBarController.swift
//  Duriso
//
//  Created by 김동현 on 8/26/24.
//

import UIKit

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mapVC = UINavigationController(rootViewController: OnlineMapViewController())
    mapVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(systemName: "globe"), tag: 0)
    
    let boardVC = UINavigationController(rootViewController: BoardViewController())
    boardVC.tabBarItem = UITabBarItem(title: "게시판", image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
    
    let guidelineVC = UINavigationController(rootViewController: GuidelineViewController())
    guidelineVC.tabBarItem = UITabBarItem(title: "행동요령", image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
    
    let mypageVC = UINavigationController(rootViewController: MyPageViewController())
    mypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.circle"), tag: 3)
    
    viewControllers = [mapVC, boardVC, guidelineVC, mypageVC]
  }
}
