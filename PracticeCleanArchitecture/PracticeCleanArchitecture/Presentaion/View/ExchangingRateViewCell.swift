//
//  ExchangingRateViewCell.swift
//
//  Created by MaraMincho on 1/16/24.
//

import UIKit

// MARK: - ExchangingRateViewCell

final class ExchangingRateViewCell: UIStackView {
  @available(*, unavailable)
  required init(coder _: NSCoder) {
    fatalError("Cant use this Init")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    setup()
  }

  private let cellTitleLabel: UILabel = {
    let label = UILabel()
    label.setContentHuggingPriority(.defaultLow, for: .horizontal)
    label.textAlignment = .right
    label.font = Constants.labelFont

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let cellDescriptionLabel: UILabel = {
    let label = UILabel()
    label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    label.font = Constants.labelFont

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private enum Constants {
    static let labelFont: UIFont = .preferredFont(forTextStyle: .title3)
  }

  private enum Metrics {
    static let spacing: CGFloat = 12
    static let cellTitleWidth: CGFloat = 120
  }
}

private extension ExchangingRateViewCell {
  func setup() {
    axis = .horizontal
    spacing = Metrics.spacing
    distribution = .fillProportionally

    addArrangedSubview(cellTitleLabel)
    addArrangedSubview(cellDescriptionLabel)

    cellTitleLabel.widthAnchor.constraint(equalToConstant: Metrics.cellTitleWidth).isActive = true
  }
}

extension ExchangingRateViewCell {
  func configureLabel(titleText: String, descriptionText: String) {
    cellTitleLabel.text = titleText
    cellDescriptionLabel.text = descriptionText
  }

  func configureDescriptionText(_ text: String?) {
    guard let text else { return }
    DispatchQueue.main.async { [weak self] in
      self?.cellDescriptionLabel.text = text
    }
  }
}
