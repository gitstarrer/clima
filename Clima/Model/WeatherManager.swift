//
//  WeatherManager.swift
//  Clima
//
//  Created by Himanshu Gupta on 15/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather : WeatherModel)
    func didFailWithError(error : Error)
}

struct  WeatherManager {
    
    var delegate : WeatherManagerDelegate?
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=0efd58e6a2fc1aa21f8534c24e6f4c2a&units=metric"
    
    func fetchWeather(cityName : String){
        let urlstring = "\(weatherUrl)&q=\(cityName)"
        performRequest(urlString: urlstring)
    }
    
    
    func performRequest (urlString : String){
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error : error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(WeatherData: safeData){
                        self.delegate?.didUpdateWeather(weather : weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON (WeatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(weatherData.self, from: WeatherData)
            let cityName = (decodedData.name)
            let temp = (decodedData.main.temp)
            let descrptn = (decodedData.weather[0].description)
            let id = decodedData.weather[0].id
            
            let weatherModel = WeatherModel(conditionID: id, cityName: cityName, temperature: temp, description: descrptn)
            return weatherModel
            
        }
        catch{
            delegate?.didFailWithError(error : error)
            return nil
        }
    }
    
    
}

extension WeatherManager {
    func fetchWeather(latitude : Double, longitude : Double) {
        let urlstring = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlstring)
    }
}

