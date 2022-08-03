//
//  WeatherData.swift
//  Clima
//
//  Created by Eugeniu Garaz on 8/3/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let wather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id          : Int
    let description : String
}
