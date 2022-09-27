//
//  WebService.swift
//  WeatherApp
//
//  Created by MinKyeongTae on 2022/09/28.
//

import Foundation
import Combine

final class WebService {
  func fetchWeather(city: String) -> AnyPublisher<Weather, Error> {
    guard let url = URL(string: Constants.URLs.weather) else {
      fatalError("Invalid URL !!")
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: WeatherResponse.self, decoder: JSONDecoder())
      .map { $0.main }
      .receive(on: RunLoop.main) // main thread에서 동작하도록 합니다.
      .eraseToAnyPublisher() // 최종적인 형태로 데이터를 전달할때 eraseToAnyPublisher를 사용할 수 있다.
  }
}
