//
//  CoinManager.swift
//  BitCoin
//
//  Created by Abdelrahman on 3/3/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(_ coinManager: CoinManager, coin: CoinData)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "C2F2F874-2E8E-4E3D-8616-6D8A4A77EF43"
    var delegate: CoinManagerDelegate?
    
    let currencyArr = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String)  {
        let urlStr = baseURL+currency+"?apiKey=\(apiKey)"
        performRequest(with: urlStr)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.didUpdateCurrency(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
        
    }
    func parseJSON(_ coinData: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let coin = CoinData(rate: rate)
            return coin
        }catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
