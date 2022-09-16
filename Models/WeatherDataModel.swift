//
//  WeatherData.swift
//  Weather
//
//  Created by Алексей Гуляев on 15.08.2022.
//

import Foundation

struct WeatherDataModel: Codable {
    
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Sys: Codable {
    let country: String
}
