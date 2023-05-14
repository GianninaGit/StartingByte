//
//  CoinData.swift
//  ByteCoin
//
//  Created by Giannina on 13/5/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

            //14c) Aquí creo la estructura que interpretará la infor recibida en el JSON. Debo indicar que esa estructura adopta el protocolo Decodable (puede interpretar info). Y la constante rate de tipo Double, lleva el nombre exacto de la API. Luego de hacer esto, vuelvo al Manager, y creo una instancia "decoder" del JSON.
struct CoinData: Codable {
    let rate: Double
    let asset_id_quote: String
}
