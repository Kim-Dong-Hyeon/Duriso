//
//  GuidelinePDFViewController.swift
//  Duriso
//
//  Created by 신상규 on 9/17/24.
//

import UIKit
import PDFKit

import SnapKit

class GuidelinePDFViewController: UIViewController {
  
  private let earthquakePdf = PDFView().then {
    $0.autoScales = true
  }
  
  var pdfFileName: String? // PDF 파일 이름을 받을 변수
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupLayout()
    loadPDF()
  }
  
  private func setupLayout() {
    view.addSubview(earthquakePdf)
    
    earthquakePdf.snp.makeConstraints {
      $0.leading.trailing.top.bottom.equalToSuperview()
    }
  }
  
  private func loadPDF() {
    guard let pdfFileName = pdfFileName else {
      print("PDF file name not set")
      return
    }
    
    if let path = Bundle.main.url(forResource: pdfFileName, withExtension: "pdf") {
      print("PDF path: \(path)") // 경로 확인
      if FileManager.default.fileExists(atPath: path.path) {
        print("PDF file exists at path")
        if let document = PDFDocument(url: path) {
          earthquakePdf.document = document
        } else {
          print("Failed to create PDFDocument")
        }
      } else {
        print("PDF file does not exist at path")
      }
    } else {
      print("PDF file not found")
    }
  }
}

