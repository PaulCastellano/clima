//
//  WeatherManager.swift
//  Clima
//
//  Created by Eugeniu Garaz on 8/3/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let watherURL = "https://api.openweathermap.org/data/2.5/wather?appid=API_ID&units=metric"
    
    var delegate: WeatherManagerDelegate?
 
    func fetchWather(cityName: String) {
        let urlString = "\(watherURL)&q=\(cityName)"
        perfomeString(with: urlString)
    }
    
    func fetchWather(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let urlString = "\(watherURL)&lon=\(long)&lat=\(lat)"
        perfomeString(with: urlString)
    }
    
    func perfomeString(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                self.delegate?.didFailWithError(error: err)
                return
            }
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    self.delegate?.didUpdateWeather(weather: weather)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ watherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: watherData)
            
            let id = decodedData.wather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}
