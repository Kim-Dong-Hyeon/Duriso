//
//  MuteListTableViewCell.swift
//  Duriso
//
//  Created by t2023-m0102 on 9/27/24.
//

import UIKit

import RxSwift

class MuteTableViewCell: UITableViewCell {
  
  var disposeBag = DisposeBag()
  
  var isEditingMode: Bool = false {
    didSet {
      if isEditingMode {
        self.textLabel?.textColor = .red
        self.textLabel?.text = self.textLabel?.text ?? ""
      } else {
        self.textLabel?.textColor = .black
      }
    }
  }
  
  private var nickname: String = ""
  
  func configure(with nickname: String) {
    self.nickname = nickname
    self.textLabel?.text = nickname
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.textLabel?.text = nil
    self.isEditingMode = false
    disposeBag = DisposeBag()
  }
}
