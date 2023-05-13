import Foundation

//12a) Video 167: Creo esta archivo CoinManager para hacer la request a la api

struct CoinManager {
    
    //12b) Éste es el URL al que debo acceder, la parte variable es BTC (dependerá de qué moneda elija el usuario con el picker) y USD (que supongo que tmb podrá editarlo) -> rest.coinapi.io/v1/exchangerate/BTC/ USD? apikey=BA04936C-C450-47D7-9904-461576CA26B5
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "secretApiKeyByte"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    //10) Crear fc. for sería el parámetro externo, que se usa al llamar a la fc; y currency sería el parametro interno, que se usa dentro de la fc.
    func getCoinPrice(for currencySelectedByUser: String) {
        //12c) Armo el URL que voy a usar y con la instancia de este manager que ya está creada en el Controller, le pido que me dé la moneda seleccionada por el usuario (esto lo hago en el punto 12d que está en el Controller. Para hacer esto, ver video 148.
        //let urlStringModificableByUserSelection = baseURL + currencySelectedByUser + "?apikey=" + apiKey
        let urlStringModificableByUserSelection = "\(baseURL)\(currencySelectedByUser)?apikey=\(apiKey)"
        print(urlStringModificableByUserSelection)
        
        //13b) Aquí ejecuto essta función para que se envíe la solicitud a la api, y le pongo la url creada arriba:
        performRequest(rawUrlString: urlStringModificableByUserSelection)
    }
    
    //13a) Ahora tengo que hacer API network REQUEST a rest.coinapi.io server, para eso creo esta función, que tiene 4 pasos:
    // 1-crear url 2-crear URLSession 3-darle una task a la session y 4-iniciar la task.
    func performRequest(rawUrlString: String) {
        //1-creo el objeto url, que es una instacia de tipo URL() y le agrego un if porque el tipo URL() es un optionalString (xq puede haber errores de tipeo), y yo tengo que pasar String. Entonces, si el url no es nil, continúa.
        if let url = URL(string: rawUrlString) {
            //2-creo el objeto session, que es una instancia de tipo URLSession(), con la configuración por default.
            let session = URLSession(configuration: .default)
            //3-darle una tarea a la sessión: dataTask(url + handler): ésto crea una tarea (asignada a la sesión -el browser-) que obtiene el contenido de una url específica (la que le paso) y luego, una vez que se completa esa tarea, llama al handler/manipulador (una función anónima, lambda, closure). Todo esto lo pongo dentro de una cajita llamada task.
            //Cuando la task se complete, y reciba los datos de la api, la misma task será la que ejecute el completionHandler
            let task = session.dataTask(with: url) { dataAPI, responseAPI, errorAPI in
                //Debo seleccionar el compleetionHandler y apretar enter para que se desglose.
                //Si la data recibida no es nula, ok, continuar, salir de ese if.
                if errorAPI != nil {
                    print(errorAPI!)
                    return
                }
                //Convierto la data recibida a string.
                let dataRecivedConvertedToString = String(data: dataAPI!, encoding: .utf8)
                print(dataRecivedConvertedToString!)
            }
            
            //4-inicio la tarea: en vez de start, se usa resume, porque al crearla, en el punto 3, por el tipo de objeto que es la sesión, se crea en modo suspendido, pero ya iniciado, entonces resume lo que hace es sacarlo de esa "pausa".
            task.resume()
        }
    }
}
