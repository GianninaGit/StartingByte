import UIKit

//16c) La clase adopta el protocolo con el delegate y añado las funciones automáticamente para que cumplan con el protocolo.
class ByteViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {

    
    //1) Añado el protocolo UIPickerViewDataSource, que define los métodos que el VC debe implementar para actuar como proveedor de datos para una vista de selección de UIPickerView.
    //5) Tenemos 3 propiedades: 2 de texto y 1 de selección.
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //2) Selecciono al ViewController como el dataSource de la rueda de cambio, es decir, el mismo controler se autodefine como proveedor de datos para la rueda. dataSource viene del protocolo UIPickerViewDataSource.
        currencyPicker.dataSource = self
        
        //6) Para completar la rueda con títulos: añado el protocolo UIPickerViewDelegate a la clase, y configuro a este mismo controller como delegado del currencyPicker.
        currencyPicker.delegate = self
        
        //16e) Acordarse de definir el delegate aca tmb:
        coinManager.delegate = self
    }
    
    //3) Con esta función, que sale del protocolo, elijo cuántas columnas: 1.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let numberOfColumns = 1
        return numberOfColumns
    }
    
    //4) Con esta función, que sale del protocolo, elijo cuántas filas. Para no contarlas, uso el método .count sobre el array que contiene las currencies (esa constante está en el Modelo CoinManager, así que creo una instancia de ese objeto, para acceder:
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let numberOfRows = coinManager.currencyArray.count
        return numberOfRows
    }
    
    //7) Para completar la rueda con títulos: añado closure titleForRow. Esta fc espera un string como output: el título de la fila en cuestión. el pickerView le preguntará a su delegado (este VC) por una fila con título, y llamará a este método por cada fila. Entonces, al querer obtener el título de la fila, el VC le pasará una fila valor 0 con un componente (columna) valor cero (posiciones iniciales). Dentro de este método, ponemos la "row:Int" para seleccionar el título de la fila: Modelo (coinManager -> instanciado arriba) dame la posición X de tu array currencyArray (donde tiene guardadas la lista de títulos). Ésto ocurrirá cada vez que el usuario ruede el picker.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let titleOfRow = coinManager.currencyArray[row]
        return titleOfRow
    }
    
    //8) Para cambiar seleccionar una fila (una moneda) de la rueda: añado closure didSelectRow. Esta fc se ejecutará cada vez que el usuario scrollee la rueda, y grabará el número de fila seleccionada.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // print(row) -> Esto, al ejecutarlo así nomás, me imprime la posición de la fila seleccionada, pero no el nombre (la moneda en sí).
        //9) Challenge: Change the code to print the currency value selected, instead of the row number.
        let selectedCurrency = coinManager.currencyArray[row]
        print(selectedCurrency)
        //10) Crear método en struct CoinManager: getCoinPrice(for currency: String)
        //11) Challenge: Update the pickerView(didSelectRow:) method to pass the selected currency to the CoinManager via the getCoinPrice() method.
        //Doncs... el VC obtiene la currency seleccionada por el usuario, y la guarda en selectedCurrency.
        //Esta fc: getCoinPrice(for currency: String) que está declarada en el Modelo CoinManager, recibe un String.
        //Doncs, a mi objeto coinManager, le aplico esta fc, y le paso como String a selectedCurrency (que es la cajita que contiene lo seleccionado):
        coinManager.getCoinPrice(for: selectedCurrency)
    }
    
    //16d) Esta fc debe cumplir con el protocolo
    func didUpdatePriceOfBitcoin(_ coinManager: CoinManager, precioByte: Double) {
        //16e) Si quiero updatear UI desde el completionHandler, dará un error. Esto se debe a que el completionHandler se encarga de ejecutar tareas grandes (como el networking) en el background. Al querer updatear UI desde la closure (donde está el handler), podría tomar minutos u horas, y en el interín, la UI estaría congelada. Para que esto no ocurra, debemos llamar al hilo principal, para que updatee la UI (falta implementar)
        print(currencyLabel.text = String(format: "%.2f", precioByte))
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

