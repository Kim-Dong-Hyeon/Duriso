import UIKit

import SnapKit
import Then

class AedViewController: UIViewController {

    var poiName: String?
    var poiAddress: String?
    var adminName: String?    // 관리자 이름
    var adminNumber: String?  // 관리자 전화번호

    private let typeStackView = UIStackView().then {
        $0.backgroundColor = .CWhite
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.layer.borderColor = UIColor.CGreen.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 13
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowColor = UIColor.CBlack.cgColor
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }

    private let typeLogo = UIImageView().then {
        $0.image = UIImage(named: "bolt.heart.fill")
        $0.contentMode = .scaleAspectFit
    }

    private let typeLabel = UILabel().then {
        $0.text = "AED"
        $0.textColor = .CRed
        $0.textAlignment = .center
        $0.font = CustomFont.Deco4.font()
    }

    private let aedName = UILabel().then {
        $0.text = "AED 위치"
        $0.textColor = .CBlack
        $0.textAlignment = .left
        $0.font = CustomFont.Head2.font()
    }

    private let aedAddress = UILabel().then {
        $0.text = "00도 00시 00구 00동"
        $0.textColor = .CBlack
        $0.textAlignment = .center
        $0.font = CustomFont.Body2.font()
    }

    private let adminInfoLabel = UILabel().then {
        $0.text = "관리자 정보"
        $0.textColor = .CBlack
        $0.textAlignment = .left
        $0.font = CustomFont.Head3.font()
    }

    private let adminNameLabel = UILabel().then {
        $0.text = "관리자 이름"
        $0.textColor = .CBlack
        $0.textAlignment = .center
        $0.font = CustomFont.Body2.font()
    }

    private let adminNumberLabel = UILabel().then {
        $0.text = "관리자 전화번호"
        $0.textColor = .CBlack
        $0.textAlignment = .center
        $0.font = CustomFont.Body2.font()
    }

    private let cancelButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.app"), for: .normal)
        $0.tintColor = .black
        $0.contentMode = .scaleAspectFit
        $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupView()
        setupConstraints()
        
        // POI 데이터 업데이트
        updatePoiData()
    }

    func setupView() {
        [
            typeLogo,
            typeLabel
        ].forEach { typeStackView.addSubview($0) }

        [
            aedName,
            typeStackView,
            aedAddress,
            adminInfoLabel,
            adminNameLabel,
            adminNumberLabel,
            cancelButton,
        ].forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        typeStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.width.equalTo(85)
            $0.height.equalTo(26)
        }

        typeLogo.snp.makeConstraints {
            $0.leading.equalTo(typeStackView.snp.leading).offset(4)
            $0.bottom.equalTo(typeStackView.snp.bottom)
            $0.height.equalTo(22)
        }

        typeLabel.snp.makeConstraints {
            $0.leading.equalTo(typeLogo.snp.trailing)
        }

        aedName.snp.makeConstraints {
            $0.top.equalTo(typeStackView.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        aedAddress.snp.makeConstraints {
            $0.top.equalTo(aedName.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        adminInfoLabel.snp.makeConstraints {
            $0.top.equalTo(aedAddress.snp.bottom).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        adminNameLabel.snp.makeConstraints {
            $0.top.equalTo(adminInfoLabel.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        adminNumberLabel.snp.makeConstraints {
            $0.top.equalTo(adminNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        cancelButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.width.height.equalTo(32)
        }
    }

    func updatePoiData() {
        // 전달받은 POI 데이터를 UILabel에 반영
        aedName.text = poiName ?? "Unknown AED"
        aedAddress.text = poiAddress ?? "Unknown Address"
        adminNameLabel.text = adminName ?? "Unknown Admin Name"
        adminNumberLabel.text = adminNumber ?? "Unknown Admin Number"
    }

    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
}
