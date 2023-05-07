import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    //1) Añado el protocolo UIPickerViewDataSource, que define los métodos que el VC debe implementar para actuar como proveedor de datos para una vista de selección de UIPickerView.
    //5) Tenemos 3 propiedades: 2 de texto y 1 de selección.
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //2) Selecciono al ViewController como el dataSource de la rueda de cambio, es decir, el mismo controler se autodefine como proveedor de datos para la ruieda. dataSource viene del protocolo UIPickerViewDataSource.
        currencyPicker.dataSource = self
        
        //6) Para completar la rueda con títulos: añado el protocolo UIPickerViewDelegate a la clase, y configuro a este mismo controller como delegado del currencyPicker.
        currencyPicker.delegate = self
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
    
    //7) Para completar la rueda con títulos: añado closure titleForRow. Esta fc espera un string como output: el título de la fila en cuestión. el PickerView le preguntará a su delegado (este VC) por una fila con título, y llamará a este método por cada fila. Entonces, al querer obtener el título de la fila, el VC le pasará una fila valor 0 con un componente (columna) valor cero (posiciones iniciales). Dentro de este método, podemos la "row:Int" para seleccionar el título de la fila: Modelo (coinManager -> instanciado arriba) dame la posición X de tu array currencyArray (donde tiene guardadas la lista de títulos). Ésto ocurrirá cada vez que el usuario ruede el picker.
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
}

