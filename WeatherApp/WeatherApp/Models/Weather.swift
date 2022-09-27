//
//  Weather.swift
//  WeatherApp
//
//  Created by MinKyeongTae on 2022/09/28.
//

import Foundation

struct WeatherResponse: Decodable {
  let main: Weather
}

struct Weather: Decodable {
  let temp: Double?
  let humidity: Double?
  
  static var placeholder: Weather {
    Weather(temp: nil, humidity: nil)
  }
}
