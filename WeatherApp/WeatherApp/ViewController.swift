//
//  ViewController.swift
//  WeatherApp
//
//  Created by MinKyeongTae on 2022/09/28.
//

// MARK: 66. Displaying Weather on the User Interface

import UIKit
import Combine

class ViewController: UIViewController {
  
  @IBOutlet weak var temperatureLabel: UILabel!
  
  private var webService = WebService()
  /// Combine publisher 구독 정보를 저장하며, ViewController 생애주기가 끝나면 알아서 메모리 해제 된다.
  /// - 메모리 해제가 정상적으로 되어 메모리 leak이 발생하지 않기 위해 publisher 구독 시, cancellable을 할당하거나, cancel() 메서드를 통해 구독을 취소하는 관리를 해주어야 한다.
  private var cancellable: AnyCancellable?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.cancellable = self.webService.fetchWeather(city: "Houston")
      .catch { _ in Just(Weather.placeholder) } // 에러 발생 시, placeholder Data를 넘깁니다.
      .map { weather in
        guard let temp = weather.temp else {
          return "Error getting weather"
        }
        return "\(temp) 𝐟"
      }.assign(to: \.text, on: self.temperatureLabel) // assign을 통해 publisher 연산 결과를 temperatureLabel text에 바인딩한다.
  }
}

