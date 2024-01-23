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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    print("view.frame.wdith")
    print("aRatioView = \(aRatioView.frame.width), bContentWidth = \(bRatioView.frame.width)")
    print("aContentWidth / bContnetWidth = \(aRatioView.frame.width / bRatioView.frame.width)")
    
    print("\nview.intrinsicContentSize")
    print("aContentWidth = \(aRatioView.intrinsicContentSize.width), bContentWidth = \(bRatioView.intrinsicContentSize.width)")
    print("aContentWidth / bContentWidth = \(aRatioView.intrinsicContentSize.width / bRatioView.intrinsicContentSize.width)")
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    
    aContentView.frame.size = .init(width: 30, height: 80)
    bContentView.frame.size = .init(width: 70, height: 80)
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
  
  let aContentView: UIView = {
    let view = UIView()
    view.backgroundColor = .red
    
    
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let bContentView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let aContentLabel: UILabel = {
    let label = UILabel()
    label.text = "에이 컨텐트 라벨"
    label.backgroundColor = .red
    label.textColor = .white
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let bContentLabel: UILabel = {
    let label = UILabel()
    label.text = "비 컨텐트 라벨 () () ()"
    label.backgroundColor = .blue
    label.textColor = .white
    
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let aRatioView = RatioView(inputIntrinsicContentSize: .init(width: 40, height: 80))
  let bRatioView = RatioView(inputIntrinsicContentSize: .init(width: 60, height: 150))
  
  private lazy var testStackView: UIStackView = {
    aRatioView.backgroundColor = .red
    bRatioView.backgroundColor = .blue
    let st = UIStackView(arrangedSubviews: [aRatioView, bRatioView])
    st.backgroundColor = .gray
    st.axis = .horizontal
    st.distribution = .fillProportionally
    st.alignment = .center
    
    st.translatesAutoresizingMaskIntoConstraints = false
    return st
  }()
  
  private func setupViewHierarchyAndConstraints() {
    
    let safeArea = view.safeAreaLayoutGuide
    view.addSubview(testStackView)
    testStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
    testStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    testStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    testStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    

//    view.addSubview(customStackView)
//    
//    customStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 23).isActive = true
//    customStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 23).isActive = true
//    customStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -23).isActive = true
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


final class RatioView: UIView {
  let inputIntrinsicContentSize: CGSize
  init(inputIntrinsicContentSize size: CGSize) {
    self.inputIntrinsicContentSize = size
    super.init(frame: .zero)
  }
  required init?(coder: NSCoder) {
    fatalError("not implemented this method")
  }
  override var intrinsicContentSize: CGSize {
    return inputIntrinsicContentSize
  }
}
