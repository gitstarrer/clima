//
//  WeatherData.swift
//  Clima
//
//  Created by Himanshu Gupta on 15/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct weatherData : Codable{
    let name : String
    let main : Main //creating a main object of type Main
    let weather : [Weather] 
}

struct Main : Codable {
    let temp:Double
}
struct Weather : Codable {
    let description : String
    let id : Int
}
