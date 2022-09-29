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
    guard let url = URL(string: Constants.weather(city: city)) else {
      fatalError("Invalid URL !!")
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data) // KeyPath를 통해 data, response 중 data만 downstream으로 이동
      .decode(type: WeatherResponse.self, decoder: JSONDecoder()) // WeatherResponse로 디코딩
      .map { $0.main } // WeatherRespons의 main: Weather 필드 데이터만 downstream으로 이동
      .catch { _ in Empty<Weather, Error>() } // 에러 발생 시 Empty 타입으로 반환할 수 있다.
      .receive(on: RunLoop.main) // main thread에서 동작하도록 합니다.
      .eraseToAnyPublisher() // 최종적인 형태로 데이터를 전달할때 eraseToAnyPublisher를 사용할 수 있다.
  }
}
