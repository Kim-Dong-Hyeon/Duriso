//
//  OfflineDataViewController.swift
//  Duriso
//
//  Created by 김동현 on 9/18/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class OfflineDataViewController: UIViewController {
  private let viewModel = OfflineDataViewModel()
  private let disposeBag = DisposeBag()
  
  private let categorySegmentedControl = UISegmentedControl(items: ["제세동기", "민방위대피소", "재난대피소"]).then {
    $0.selectedSegmentIndex = 0
  }
  
  private let pickerStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 10
  }
  
  private let cityPicker = UIPickerView()
  private let districtPicker = UIPickerView()
  private let townPicker = UIPickerView()
  
  private let tableView = UITableView().then {
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  private let cities = City.allCases
  private let districts = District.districts
  private let towns = Town.towns
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    bindViewModel()
    setupPickers()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    [
      categorySegmentedControl,
      pickerStackView,
      tableView
    ].forEach { view.addSubview($0) }
    
    [
      cityPicker,
      districtPicker,
      townPicker
    ].forEach { pickerStackView.addArrangedSubview($0) }
    
    categorySegmentedControl.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.left.right.equalToSuperview().inset(20)
    }
    
    pickerStackView.snp.makeConstraints {
      $0.top.equalTo(categorySegmentedControl.snp.bottom).offset(20)
      $0.left.right.equalToSuperview().inset(20)
      $0.height.equalTo(150)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(pickerStackView.snp.bottom).offset(20)
      $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
    }
  }
  
  private func bindViewModel() {
    categorySegmentedControl.rx.selectedSegmentIndex
      .map { ["제세동기", "민방위대피소", "재난대피소"][$0] }
      .bind(to: viewModel.category)
      .disposed(by: disposeBag)
    
    viewModel.filteredItems
      .do(onNext: { items in
        print("Filtered items to display: \(items.count)")
      })
      .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { [weak self] index, item, cell in
        self?.configureCell(cell, with: item)
      }
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Any.self)
      .subscribe(onNext: { [weak self] item in
        let detailVC = DetailViewController(item: item)
        self?.navigationController?.pushViewController(detailVC, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func configureCell(_ cell: UITableViewCell, with item: Any) {
    cell.textLabel?.numberOfLines = 0
    cell.detailTextLabel?.numberOfLines = 0
    
    switch item {
    case let aed as OfflineAED:
      cell.textLabel?.text = aed.org
      cell.detailTextLabel?.text = aed.buildAddress
    case let civilDefenseShelter as OfflineCivilDefenseShelter:
      cell.textLabel?.text = civilDefenseShelter.placeName
      cell.detailTextLabel?.text = civilDefenseShelter.ronaAddress
    case let disasterShelter as OfflineDisasterShelter:
      cell.textLabel?.text = disasterShelter.placeName
      cell.detailTextLabel?.text = disasterShelter.ronaAddress
    default:
      cell.textLabel?.text = "Unknown item"
      cell.detailTextLabel?.text = ""
    }
  }
  
  private func setupPickers() {
    [
      cityPicker,
      districtPicker,
      townPicker
    ].forEach {
      $0.delegate = self
      $0.dataSource = self
    }
    
    // 초기 선택 설정
    cityPicker.selectRow(0, inComponent: 0, animated: false)
    updateDistrictPicker()
    updateTownPicker()
  }
  
  private func updateDistrictPicker() {
    districtPicker.reloadAllComponents()
    if let districts = districts[cities[cityPicker.selectedRow(inComponent: 0)]], !districts.isEmpty {
      districtPicker.selectRow(0, inComponent: 0, animated: false)
    }
    updateTownPicker()
  }
  
  private func updateTownPicker() {
    townPicker.reloadAllComponents()
    let selectedCity = cities[cityPicker.selectedRow(inComponent: 0)]
    let districtIndex = districtPicker.selectedRow(inComponent: 0)
    if let districts = districts[selectedCity], districtIndex < districts.count,
       let selectedDistrict = districts[safe: districtIndex],
       let towns = towns["\(selectedCity.rawValue)_\(selectedDistrict)"],
       !towns.isEmpty {
      townPicker.selectRow(0, inComponent: 0, animated: false)
    }
  }
}

extension OfflineDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView {
    case cityPicker:
      return cities.count
    case districtPicker:
      let selectedCity = cities[cityPicker.selectedRow(inComponent: 0)]
      return districts[selectedCity]?.count ?? 0
    case townPicker:
      let selectedCity = cities[cityPicker.selectedRow(inComponent: 0)]
      let selectedDistrict = districts[selectedCity]?[districtPicker.selectedRow(inComponent: 0)] ?? ""
      return towns["\(selectedCity.rawValue)_\(selectedDistrict)"]?.count ?? 0
    default:
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView {
    case cityPicker:
      return cities[row].rawValue
    case districtPicker:
      let selectedCity = cities[cityPicker.selectedRow(inComponent: 0)]
      return districts[selectedCity]?[row]
    case townPicker:
      let selectedCity = cities[cityPicker.selectedRow(inComponent: 0)]
      let selectedDistrict = districts[selectedCity]?[districtPicker.selectedRow(inComponent: 0)] ?? ""
      return towns["\(selectedCity.rawValue)_\(selectedDistrict)"]?[row]
    default:
      return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedCity = cities[cityPicker.selectedRow(inComponent: 0)]
    let districtIndex = districtPicker.selectedRow(inComponent: 0)
    let selectedDistrict = districts[selectedCity]?[safe: districtIndex] ?? ""
    let townIndex = townPicker.selectedRow(inComponent: 0)
    let selectedTown = towns["\(selectedCity.rawValue)_\(selectedDistrict)"]?[safe: townIndex] ?? ""
    
    viewModel.city.accept(selectedCity.rawValue)
    viewModel.district.accept(selectedDistrict)
    viewModel.town.accept(selectedTown)
    
    if pickerView == cityPicker {
      updateDistrictPicker()
    } else if pickerView == districtPicker {
      updateTownPicker()
    }
  }
}

// 배열에 안전하게 접근하기 위한 extension
extension Array {
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
