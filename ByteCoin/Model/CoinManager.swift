import Foundation

//16) Video 169: Creo protocolo para actualizar User Interface
protocol CoinManagerDelegate {
    func didUpdatePriceOfBitcoin(_ coinManager: CoinManager, precioByte: Double)
    func didFailWithError(error: Error)
}

//12a) Video 167: Creo esta archivo CoinManager para hacer la request a la api
struct CoinManager {
    
    //12b) Éste es el URL al que debo acceder, la parte variable es BTC (dependerá de qué moneda elija el usuario con el picker) y USD (que supongo que tmb podrá editarlo) -> rest.coinapi.io/v1/exchangerate/BTC/ USD? apikey={}
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "insertar api key
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    //16a)Creo la variable delegate de tipo protocolo, para que esta struct pueda acceder a las fc del protocolo. Cualquier clase o struct que se autodefina como delegate, deberá cumplir con el protocolo CoinManagerDelegate:
    var delegate: CoinManagerDelegate?
    
    //10) Crear fc. for sería el parámetro externo, que se usa al llamar a la fc; y currency sería el parametro interno, que se usa dentro de la fc.
    func getCoinPrice(for currencySelectedByUser: String) {
        //12c) Armo el URL que voy a usar y con la instancia de este manager que ya está creada en el Controller, le pido que me dé la moneda seleccionada por el usuario (esto lo hago en el punto 12d que está en el Controller. Para hacer esto, ver video 148.
        //let urlStringModificableByUserSelection = baseURL + currencySelectedByUser + "?apikey=" + apiKey
        let urlStringModificableByUserSelection = "\(baseURL)\(currencySelectedByUser)?apikey=\(apiKey)"
        print(urlStringModificableByUserSelection)
        
        //13b) Aquí ejecuto essta función para que se envíe la solicitud a la api, y le pongo la url creada arriba:
        performRequest(with: urlStringModificableByUserSelection) //15c) Agrego el with.
    }
    
    //13a) Ahora tengo que hacer API network REQUEST a rest.coinapi.io server, para eso creo esta función, que tiene 4 pasos:
    // 1-crear url 2-crear URLSession 3-darle una task a la session y 4-iniciar la task.
    func performRequest(with rawUrlString: String) { //15b) Agrego el with para usarlo de parámetro extero al llamar a la fc arriba.
        //1-creo el objeto url, que es una instacia de tipo URL() y le agrego un if porque el tipo URL() es un optionalString (xq puede haber errores de tipeo), y yo tengo que pasar String. Entonces, si el url no es nil, continúa.
        if let url = URL(string: rawUrlString) {
            //2-creo el objeto session, que es una instancia de tipo URLSession(), con la configuración por default.
            let session = URLSession(configuration: .default)
            //3-darle una tarea a la sessión: dataTask(url + handler): ésto crea una tarea (asignada a la sesión -el browser-) que obtiene el contenido de una url específica (la que le paso) y luego, una vez que se completa esa tarea, llama al handler/manipulador (una función anónima, lambda, closure). Todo esto lo pongo dentro de una cajita llamada task.
            //Cuando la task se complete, y reciba los datos de la api, la misma task será la que ejecute el completionHandler
            let task = session.dataTask(with: url) { dataAPI, responseAPI, errorAPI in
                //Debo seleccionar el compleetionHandler y apretar enter para que se desglose.
                //Si la data recibida no es nula, ok, continuar, salir de ese if.
                //16c) Si durante la task hubo un error (ej, pérdida de conexión de internet), quien sea el delegate, que ejecute la fc de error (acordarse del self. antes!! estoy en closure!)
                if errorAPI != nil {
                    self.delegate?.didFailWithError(error: errorAPI!)
                    print(errorAPI!)
                    return
                }
                //Convierto la data recibida a string.
                //let dataRecivedConvertedToString = String(data: dataAPI!, encoding: .utf8)
                //print(dataRecivedConvertedToString!)
                //14b)Agrego la función para interpretar el JSON, y le paso la info recibida de la api. Agregar self para que esta fc aplique sobre este CoinManager (hay que aclararlo porque estoy dentro de una closure).
                if let criptoInfoFromApi = self.parseJSON(dataAPI!) {//14g) Pongo esto en una constante xq da error sino. 14i) Le añado un if porque sino da un warning (porque el json ahora entrega un type Double opcional.
                    //15a) Borré el parámetro cryptoValueRecived de func parseJSON(_ cryptoValueRecived: Data) -> Double?
                    //16b) Si la info de la api es correcta, quiero pasarla al controler, para eso uso el delegate: Quien sea que se haya autodefinido como delegate(el controller), podrá usar esta fc: (y acordarse de poner el self. adelante xq estoy en una closure)
                    self.delegate?.didUpdatePriceOfBitcoin(self, precioByte: criptoInfoFromApi)
                }
            }
            
            //4-inicio la tarea: en vez de start, se usa resume, porque al crearla, en el punto 3, por el tipo de objeto que es la sesión, se crea en modo suspendido, pero ya iniciado, entonces resume lo que hace es sacarlo de esa "pausa".
            task.resume()
        }
    }
    //14a) Video 168: Interpretar el JSON: creo esta función, que va a manejar un parámetro "cryptoValueRecived", de tipo Data, que contendrá la info recibida por la API, enformato JSON. Esta función debo agregarla en la función de performRequest, en la parte que se analiza a la Data
    func parseJSON(_ cryptoValueRecived: Data) -> Double? { //14f) Hago que esta fc retorne un type Doble (rate)
    //14c) Ver video 151. Debo informar al compilador cómo está estructurada la info recibida en el JSON, para eso, hago otro archivo: CoinData.
        //14d) Creo el decoder, y le aplico el método .decode, que recibe un TIPO de datos Decodable -> CoinData sería, que contiene el protocolo Decodable. Si solo pongo CoinData, estaría pasando un OBJETO, pero como lo que espera es un TYPE, debo agregarle .self al final.
        //15) A ésta fc func parseJSON(_ cryptoValueRecived: Data) -> Double? le pongo el _ adelante, y cuando la llamo, arriba, borro el parámetro.
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: cryptoValueRecived) //14e) si no le pongo el try, da error porque no se está "manageando" el error, en caso de que hubiese. También debo empaquetarlo dentro de un bloque do + catch. Y como el método .decode espera un output, pongo esto en una constante, que puedo retornar. Esta cajita "decodedData" es un objeto de tipo CoinData, lo que significa que TIENE EL DATO DEL JSON que me interesa: RATE.
            let criptoRate = decodedData.rate
            print(criptoRate)
            return criptoRate //14h) Acordarse de retornar el double
        } catch {
            //16d) Aquí también pueden haber errores, si la interpretación del JSON va mal. 
            delegate?.didFailWithError(error: error)
            print(error)
            return nil //14h) Acordarse de retornar nil, y para que no de error, hacer opcional al return de la fc: ->Double?
        }
    }
}
