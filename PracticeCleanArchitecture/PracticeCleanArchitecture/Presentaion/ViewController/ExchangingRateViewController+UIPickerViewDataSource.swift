//
//  ExchangingRateViewController+UIPickerViewDataSource.swift
//
//  Created by MaraMincho on 1/16/24.
//

import UIKit

extension ExchangingRateViewController: UIPickerViewDataSource {
  func numberOfComponents(in _: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
    return viewModel.countOfReceiveCountry()
  }
}
