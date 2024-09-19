import UIKit

import SnapKit
import Then

class EmergencyReportViewController: UIViewController {
  
  var reportName: String?     // 보고서 이름
  var reportAddress: String?  // 보고서 주소
  
  private let poiViewTitle = UILabel().then {
    $0.text = "우리 동네 한줄 제보"
    $0.textColor = .CBlack
    $0.textAlignment = .left
    $0.font = CustomFont.Deco2.font()
  }
  
  private let megaphoneLabel = UIImageView().then {
    $0.image = UIImage(systemName: "megaphone")
    $0.tintColor = .CRed
    $0.contentMode = .scaleAspectFit
  }
  
  private let poiViewAddress = UILabel().then {
    $0.text = "마커 위치 정보 가져오는 중"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body2.font()
  }
  
  private let postTime = UILabel().then {
    $0.text = "00분전"
    $0.textColor = .CBlack
    $0.textAlignment = .center
    $0.font = CustomFont.Body3.font()
  }
  
  private let cancelButton = UIButton().then {
    $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    $0.tintColor = .CLightBlue
    $0.contentMode = .scaleAspectFit
    $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
  }
  
  private let postMessage = UITextView().then {
    $0.backgroundColor = UIColor.CLightBlue
    $0.font = CustomFont.Body2.font()
    $0.text = "꼭 필요한 긴급 정보만 남겨주세요!"
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupView()
    setupConstraints()
    updatePoiData()  // ViewController가 로드된 후에 데이터를 업데이트합니다.
  }
  
  func setupView() {
    [
      poiViewTitle,
      megaphoneLabel,
      poiViewAddress,
      postTime,
      cancelButton,
      postMessage
    ].forEach { view.addSubview($0) }
  }
  
  func setupConstraints() {
    poiViewTitle.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    poiViewAddress.snp.makeConstraints {
      $0.top.equalTo(poiViewTitle.snp.bottom).offset(16)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
    }
    
    postTime.snp.makeConstraints {
      $0.bottom.equalTo(megaphoneLabel.snp.bottom)
      $0.leading.equalTo(megaphoneLabel.snp.trailing).offset(8)
    }
    
    megaphoneLabel.snp.makeConstraints{
      $0.centerY.equalTo(poiViewTitle.snp.centerY)
      $0.leading.equalTo(poiViewTitle.snp.trailing).offset(4)
      $0.width.height.equalTo(32)
    }
    
    cancelButton.snp.makeConstraints {
      $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.width.height.equalTo(32)
    }
    
    postMessage.snp.makeConstraints {
      $0.centerX.equalTo(view.safeAreaLayoutGuide)
      $0.top.equalTo(poiViewAddress.snp.bottom).offset(16)
      $0.width.equalTo(350)
      $0.height.equalTo(38)
    }
  }
  
  func updatePoiData() {
    // 전달받은 POI 데이터를 UILabel에 반영
    poiViewTitle.text = reportName ?? "Unknown Report"
    poiViewAddress.text = reportAddress ?? "Unknown Address"
  }
  
  @objc func didTapCancelButton() {
    dismiss(animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  EmergencyReportViewController()
}
