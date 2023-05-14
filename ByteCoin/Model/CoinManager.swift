import Foundation

protocol CoinManagerDelegate {
    func didUpdatePriceOfBitcoin(_ coinManagerInternalParameter: CoinManager, precioByte: Double)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "insertar apikey"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currencySelectedByUser: String) {

        let urlStringModificableByUserSelection = "\(baseURL)\(currencySelectedByUser)?apikey=\(apiKey)"
        performRequest(with: urlStringModificableByUserSelection) //15c) Agrego el with.
    }

    func performRequest(with rawUrlString: String) {

        if let url = URL(string: rawUrlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { dataAPI, responseAPI, errorAPI in
                if errorAPI != nil {
                    self.delegate?.didFailWithError(error: errorAPI!)
                    print(errorAPI!)
                    return
                }
                if let criptoInfoFromApi = self.parseJSON(dataAPI!) {
                    self.delegate?.didUpdatePriceOfBitcoin(self, precioByte: criptoInfoFromApi)
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ cryptoValueRecived: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: cryptoValueRecived)
            let criptoRate = decodedData.rate
            print(criptoRate)
            return criptoRate
        } catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
