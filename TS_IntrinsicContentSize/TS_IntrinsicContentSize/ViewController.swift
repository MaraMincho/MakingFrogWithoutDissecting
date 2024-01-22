//
//  ViewController.swift
//  TS_IntrinsicContentSize
//
//  Created by MaraMincho on 1/22/24.
//

import UIKit

final class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupStyle()
    setupViewHierarchyAndConstraints()
  }
  
  func setupStyle() {
    view.backgroundColor = .white
  }
  
  private let content: [CustomCellView] = [
    .init(titleText: "이름", descriptionText: "누구세요"),
    .init(titleText: "번호", descriptionText: "2017142034"),
    .init(titleText: "사람", descriptionText: "사랑해")
  ]
  private lazy var customStackView: UIStackView = {
   
    let st = UIStackView(arrangedSubviews: content)
    st.spacing = 15
    st.axis = .vertical
    
    st.translatesAutoresizingMaskIntoConstraints = false
    return st
  }()
  
  private func setupViewHierarchyAndConstraints() {
    
    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(customStackView)
    
    customStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 23).isActive = true
    customStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
    customStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true
//    customStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
  }
}


// MARK: - CustomCellView
final class CustomCellView: UIStackView {
  
  init(titleText: String?, descriptionText: String?) {
    super.init(frame: .zero)
    setupText(titleText: titleText, descriptionText: descriptionText)
    setupStyle()
    setupViewHierarchyAndConstraints()
    setupStackViewProperty()
  }
  
  required init(coder: NSCoder) {
    fatalError("이 생성자는 사용할 수 없습니다.")
  }
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.setContentHuggingPriority(.defaultLow, for: .vertical)
    label.backgroundColor = .red
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.setContentHuggingPriority(.defaultHigh, for: .vertical)
    label.backgroundColor = .blue
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  func setupStyle() {
    addArrangedSubview(titleLabel)
    addArrangedSubview(descriptionLabel)
  }
  
  func setupText(titleText: String?, descriptionText: String?) {
    titleLabel.text = titleText
    descriptionLabel.text = descriptionText
  }
  
  func setupViewHierarchyAndConstraints() {
    titleLabel.widthAnchor.constraint(equalToConstant: Metrics.titleLabelWidth).isActive = true
  }
  func setupStackViewProperty() {
    distribution = .fillProportionally
    spacing = Metrics.spacing
  }
  
  enum Metrics {
    static let titleLabelWidth: CGFloat = 50
    static let spacing: CGFloat = 15
  }
}

