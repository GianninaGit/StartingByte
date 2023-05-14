import UIKit

class ByteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    func didUpdatePriceOfBitcoin(_ coinManagerInternalParameter: CoinManager, precioByte: Double, nombreMoneda: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", precioByte)
            self.currencyLabel.text = nombreMoneda
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfColumns = 1
        return numberOfColumns
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberOfRows = coinManager.currencyArray.count
        return numberOfRows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titleOfRow = coinManager.currencyArray[row]
        return titleOfRow
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        print(selectedCurrency)
        coinManager.getCoinPrice(for: selectedCurrency)
        //currencyLabel.text = selectedCurrency -> funciona, pero no es conceptualmente incorrecto porque la info debería venir del modelo.
    }
}
