//
//  ExchangingRateViewController.swift
//
//  Created by MaraMincho on 1/16/24.
//

import Combine
import UIKit

// MARK: - ExchangingRateViewController

final class ExchangingRateViewController: UIViewController {
  init(viewModel: ExchangingRateViewModelRepresentable) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("Cant use this init")
  }

  // MARK: - Property

  var subscription: Set<AnyCancellable> = .init()

  let viewModel: ExchangingRateViewModelRepresentable

  let didPickerSelectIndexPublisher: PassthroughSubject<(row: Int, textFieldText: String?), Never> = .init()
  let textFieldTextPublisher: PassthroughSubject<String?, Never> = .init()
  let fetchLiveDataPublisher: PassthroughSubject<Void, Never> = .init()

  // MARK: - UIComponent

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.titleLabelFont
    label.text = Constants.titleLabelText

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var sendCountryCell: ExchangingRateViewCell = {
    let view = ExchangingRateViewCell()
    view.configureLabel(titleText: Constants.sendCountryCellTitleText, descriptionText: Constants.sendCountryCellDescriptionText)

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var receiveCountryCell: ExchangingRateViewCell = {
    let view = ExchangingRateViewCell()
    view.configureLabel(titleText: Constants.receiveCountryCellTitleText, descriptionText: " ")

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var exchangingRateCell: ExchangingRateViewCell = {
    let view = ExchangingRateViewCell()
    view.configureLabel(titleText: Constants.exchangingRateCellTitleText, descriptionText: " ")

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var timeOfFetchedExchangeRateCell: ExchangingRateViewCell = {
    let view = ExchangingRateViewCell()
    view.configureLabel(titleText: Constants.timeOfFetchedExchangeRateCellTitleText, descriptionText: " ")

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var exchangingRateViewCellStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [
      sendCountryCell,
      receiveCountryCell,
      exchangingRateCell,
      timeOfFetchedExchangeRateCell,
    ])
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
    stackView.spacing = Metrics.cellVerticalSpacing

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private let remittanceCellTitleLabel: UILabel = {
    let label = UILabel()
    label.text = Constants.remittanceCellTitleText
    label.font = Constants.cellLabelFont
    label.textAlignment = .right

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var remittanceTextFieldView: UITextField = {
    let tf = UITextField()
    tf.textAlignment = .right
    tf.keyboardType = .numberPad
    tf.font = Constants.textFieldFont
    tf.layer.borderWidth = Constants.textFieldBorderWidth
    tf.layer.borderColor = Constants.textFieldBorderColor

    tf.inputAccessoryView = makeTollBar()
    tf.translatesAutoresizingMaskIntoConstraints = false
    return tf
  }()

  private let unitedStatesDollarLabel: UILabel = {
    let label = UILabel()
    label.text = Constants.unitedStatesDollarLabelText
    label.font = Constants.cellLabelFont

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let exchangeConvertedLabel: UILabel = {
    let label = UILabel()
    label.font = Constants.exchangeConvertedLabelFont

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var countryPickerView: UIPickerView = {
    let view = UIPickerView()
    view.dataSource = self
    view.delegate = self

    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private func setupViewHierarchyAndConstraints() {
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(titleLabel)
    titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.titleTopSpacing).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    view.addSubview(exchangingRateViewCellStackView)
    exchangingRateViewCellStackView.topAnchor
      .constraint(equalTo: titleLabel.bottomAnchor, constant: Metrics.exchangingRateViewCellStackViewTopAnchor).isActive = true
    exchangingRateViewCellStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    exchangingRateViewCellStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

    view.addSubview(remittanceCellTitleLabel)
    remittanceCellTitleLabel.topAnchor
      .constraint(equalTo: exchangingRateViewCellStackView.bottomAnchor, constant: Metrics.cellVerticalSpacing).isActive = true
    remittanceCellTitleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    remittanceCellTitleLabel.widthAnchor.constraint(equalToConstant: Metrics.cellTitleWidth).isActive = true

    view.addSubview(remittanceTextFieldView)
    remittanceTextFieldView.topAnchor.constraint(equalTo: remittanceCellTitleLabel.topAnchor).isActive = true
    remittanceTextFieldView.leadingAnchor
      .constraint(equalTo: remittanceCellTitleLabel.trailingAnchor, constant: Metrics.cellTitleAndDescriptionSpacing).isActive = true
    remittanceTextFieldView.widthAnchor.constraint(equalToConstant: Metrics.textFieldWidth).isActive = true

    view.addSubview(unitedStatesDollarLabel)
    unitedStatesDollarLabel.topAnchor.constraint(equalTo: remittanceCellTitleLabel.topAnchor).isActive = true
    unitedStatesDollarLabel.leadingAnchor
      .constraint(equalTo: remittanceTextFieldView.trailingAnchor, constant: Metrics.unitedStatesdollarLabelLeadingSpacing).isActive = true

    view.addSubview(exchangeConvertedLabel)
    exchangeConvertedLabel.topAnchor
      .constraint(equalTo: remittanceCellTitleLabel.bottomAnchor, constant: Metrics.exchangeConvertedLabelTopSpacing).isActive = true
    exchangeConvertedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    view.addSubview(countryPickerView)
    countryPickerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: Metrics.countryPickerViewBottomSpacing).isActive = true
    countryPickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
    countryPickerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
  }

  // MARK: - Internal Method

  /// 내부 textFieldTextPublisher에 현재 remittanceTextFieldView.text를 전달합니다.
  func sendTextFieldPublisher() {
    textFieldTextPublisher.send(remittanceTextFieldView.text)
  }

  // MARK: - ViewLifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    // 초기 라벨의 Text를 설정해주는 코드 입니다.
    didPickerSelectIndexPublisher.send((row: countryPickerView.selectedRow(inComponent: 0), textFieldText: remittanceTextFieldView.text))
    fetchLiveDataPublisher.send()
  }

  // MARK: - Constants

  private enum Metrics {
    static let cellTtileLabelWidth: CGFloat = 60

    static let cellLeadingSpacing: CGFloat = 23
    static let cellTrailingSpacing: CGFloat = -23

    static let titleTopSpacing: CGFloat = 33

    static let exchangingRateViewCellStackViewTopAnchor: CGFloat = 24

    static let cellVerticalSpacing: CGFloat = 12

    static let cellTitleWidth: CGFloat = 120
    static let cellTitleAndDescriptionSpacing: CGFloat = 15

    static let textFieldWidth: CGFloat = 150

    static let unitedStatesdollarLabelLeadingSpacing: CGFloat = 15

    static let exchangeConvertedLabelTopSpacing: CGFloat = 50

    static let countryPickerViewBottomSpacing: CGFloat = 35
    static let countryPickerViewHeight: CGFloat = 140
  }

  private enum Constants {
    static let titleLabelText = "환율 계산"
    static let titleLabelFont: UIFont = .systemFont(ofSize: 50)

    static let sendCountryCellTitleText = "송금국가 :"
    static let sendCountryCellDescriptionText = "미국"
    static let receiveCountryCellTitleText = "수취국가 :"
    static let exchangingRateCellTitleText = "환율 :"
    static let timeOfFetchedExchangeRateCellTitleText = "조회시간 :"

    static let remittanceCellTitleText = "송금액 :"
    static let unitedStatesDollarLabelText = "USD"
    static let cellLabelFont: UIFont = .preferredFont(forTextStyle: .title3)

    static let textFieldFont: UIFont = .preferredFont(forTextStyle: .headline)
    static let textFieldBorderWidth: CGFloat = 2
    static let textFieldBorderColor: CGColor = UIColor.gray.cgColor

    static let exchangeConvertedLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
    static let exchangeConvertedLabelWrongColor: UIColor = .red
    static let exchangeConvertedLabelNormalColor: UIColor = .black
  }
}

private extension ExchangingRateViewController {
  func setup() {
    setupStyle()
    setupViewHierarchyAndConstraints()
    bind()
  }

  func bind() {
    bindViewModel()
    bindTextField()
    bindGesture()
  }

  func bindViewModel() {
    let output = viewModel.transform(
      input: .init(
        didSelectIndexPublisher: didPickerSelectIndexPublisher.eraseToAnyPublisher(),
        textFieldTextPublisher: textFieldTextPublisher.eraseToAnyPublisher(),
        fetchLiveDataPublisher: fetchLiveDataPublisher.eraseToAnyPublisher()
      )
    )

    output.sink { [weak self] state in
      switch state {
      case .emptyTextField:
        self?.emptyTextField()
      case let .updateCountry(value):
        self?.updateCountry(value)
      case let .updateExchangeConvertedText(value):
        self?.updateExchangeConvertedText(value)
      case .wrongTextFieldText:
        self?.showWrongTextField()
      case let .updateTimeStamp(time):
        self?.timeOfFetchedExchangeRateCell.configureDescriptionText(time)
      case let .fetch(state):
        self?.applyFetchState(state)
      case .idle:
        break
      }
    }.store(in: &subscription)
  }

  /// FetchState에 따라 View를 Update합니다.
  func applyFetchState(_ state: FetchState) {
    DispatchQueue.main.async { [weak self] in
      switch state {
      case .firstRunning:
        self?.exchangeConvertedLabel.text = "정보를 받아오는 중입니다."
        self?.remittanceTextFieldView.isEnabled = false
      case .done,
           .running:
        self?.sendTextFieldPublisher()
        self?.remittanceTextFieldView.isEnabled = true
      }
    }
  }

  func bindTextField() {
    remittanceTextFieldView.publisher(.allEvents)
      .compactMap { $0 as? UITextField }
      .sink { [weak self] textField in
        self?.textFieldTextPublisher.send(textField.text)
      }
      .store(in: &subscription)
  }

  func bindGesture() {
    let tapPublisher = UITapGestureRecognizer(target: self, action: #selector(resignTextFieldFirstResponder))
    view.addGestureRecognizer(tapPublisher)
  }

  func emptyTextField() {
    exchangeConvertedLabel.text = ""
  }

  func updateExchangeConvertedText(_ value: String) {
    exchangeConvertedLabel.textColor = Constants.exchangeConvertedLabelNormalColor
    exchangeConvertedLabel.text = "수취금액은 \(value) 입니다"
  }

  func showWrongTextField() {
    exchangeConvertedLabel.textColor = Constants.exchangeConvertedLabelWrongColor
    exchangeConvertedLabel.text = "잘못된 입력입니다. 다시 입력해 주세요"
  }

  func updateCountry(_ value: ExchangingRateViewUpdatableProperty) {
    exchangingRateCell.configureDescriptionText(value.exchangingRateText)
    receiveCountryCell.configureDescriptionText(value.receiveCountryText)
  }

  func setupStyle() {
    view.backgroundColor = .white
  }

  private func makeTollBar() -> UIToolbar {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(resignTextFieldFirstResponder))

    toolbar.items = [doneButton]

    return toolbar
  }

  @objc func resignTextFieldFirstResponder() {
    remittanceTextFieldView.resignFirstResponder()
  }
}

// MARK: - ExchangingRateViewUpdatableProperty

struct ExchangingRateViewUpdatableProperty {
  let receiveCountryText: String?
  let exchangingRateText: String?
}
