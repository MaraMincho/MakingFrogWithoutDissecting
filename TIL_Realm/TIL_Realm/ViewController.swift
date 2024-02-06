//
//  ViewController.swift
//  TIL_Realm
//
//  Created by MaraMincho on 2/6/24.
//

import UIKit
import CombineCocoa
import RealmSwift
import OSLog
import Combine

class ViewController: UIViewController {
  
  let nameTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "이름"
    textField.tintColor = UIColor.red
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let schoolTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "학교"
    textField.tintColor = UIColor.red
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  let submitButton: UIButton = {
    let button = UIButton()
    var configure = UIButton.Configuration.filled()
    configure.attributedTitle = .init("제출하세요")
    configure.baseForegroundColor = .black
    configure.baseBackgroundColor = UIColor.cyan
    button.configuration = configure
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let printButton: UIButton = {
    let button = UIButton()
    var configure = UIButton.Configuration.filled()
    configure.attributedTitle = .init("출력하세요")
    configure.baseForegroundColor = .black
    configure.baseBackgroundColor = UIColor.blue
    button.configuration = configure
    
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      nameTextField,
      schoolTextField,
      submitButton,
      printButton
    ])
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = 15
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    view.backgroundColor = .white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    try? realm.write {
      let nameSchools = realm.objects(NameSchool.self)
      
      realm.delete(nameSchools)
    }
  }
  
  func setupLayout() {
    let safeArea = view.safeAreaLayoutGuide
    
    view.addSubview(stackView)
    stackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24).isActive = true
    stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24).isActive = true
    bind()
  }
  
  var subscriptions = Set<AnyCancellable>()
  
  let realm = try! Realm()
  func bind() {
    submitButton.tapPublisher.sink { [weak self] _ in
      self?.saveData()
    }
    .store(in: &subscriptions)
    
    printButton.tapPublisher.sink { [weak self] _ in
      self?.printData()
    }
    .store(in: &subscriptions)
  }
  
  func saveData() {
    try? realm.write{
      let nameAndSchool = NameSchool(name: nameTextField.text, school: schoolTextField.text)
      realm.add(nameAndSchool)
    }
  }
  
  func printData() {
    let nameAndSchool = realm.objects(NameSchool.self)
    print(nameAndSchool)
  }
}

final class NameSchool: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String?
  @Persisted var school: String?
  @Persisted var test: TestProperty?
  
  convenience init(name: String?, school: String?) {
    self.init()
    self.name = name
    self.school = school
  }
}

final class TestProperty: EmbeddedObject {
  @Persisted var test: String = ["a", "b", "c", "d", "e", "f", "g", "h"].shuffled()[0]
}
