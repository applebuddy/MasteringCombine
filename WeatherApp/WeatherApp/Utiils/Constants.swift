//
//  Constants.swift
//  WeatherApp
//
//  Created by MinKyeongTae on 2022/09/28.
//

import Foundation

struct Constants {
  static func weather(city: String) -> String {
    return "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=83ac5aa4b3c35a75018e9ffe83d7060d&units=imperial"
  }
}
