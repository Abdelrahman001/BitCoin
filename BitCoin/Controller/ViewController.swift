//
//  ViewController.swift
//  BitCoin
//
//  Created by Abdelrahman on 3/3/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var coinView: UIView!
    
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        coinManager.delegate = self
        coinView.layer.cornerRadius = 40
        coinView.layer.masksToBounds = true
    }
}
//MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArr[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArr[row]
        coinManager.getCoinPrice(for: currency)
        currencyLabel.text = currency
        
    }
}
//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinData) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format:"%.2f",coin.rate)
        }
    }
}

