//
//  ExchangingRateViewController+UIPickerViewDelegate.swift
//
//  Created by MaraMincho on 1/16/24.
//

import UIKit

extension ExchangingRateViewController: UIPickerViewDelegate {
  func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
    didPickerSelectIndexPublisher.send((row: row, textFieldText: remittanceTextFieldView.text))
    fetchLiveDataPublisher.send()
  }

  func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
    return viewModel.pickerTitle(index: row)
  }
}
