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
  @IBOutlet weak var cityTextField: UITextField!
  
  private var webService = WebService()
  /// Combine publisher 구독 정보를 저장하며, ViewController 생애주기가 끝나면 알아서 메모리 해제 된다.
  /// - 메모리 해제가 정상적으로 되어 메모리 leak이 발생하지 않기 위해 publisher 구독 시, cancellable을 할당하거나, cancel() 메서드를 통해 구독을 취소하는 관리를 해주어야 한다.
  private var cancellable: AnyCancellable?

  override func viewDidLoad() {
    super.viewDidLoad()
    setupPublishers()

    /*
    self.cancellable = self.webService.fetchWeather(city: "Houston")
      .catch { _ in Just(Weather.placeholder) } // 에러 발생 시, placeholder Data를 넘깁니다.
      .map { weather in
        guard let temp = weather.temp else {
          return "Error getting weather"
        }
        return "\(temp) 𝐟"
      }.assign(to: \.text, on: self.temperatureLabel) // assign을 통해 publisher 연산 결과를 temperatureLabel text에 바인딩한다.
     */
  }
  // debounce operator : 특정 시간 동안 변화가 없을때 stream이 실행되도록 할 수 있다. 키워드 검색 기능에 활용하면 유용하다.
  // -> 불필요한 API 호출을 방지하는 operator 중 하나로, 잘 활용하는 것이 좋다. (자매품 : 단시간에 중복 이벤트 방지를 위해 사용 가능한 throttle operator가 있다.)
  // ex) 입력중에는 검색동작을 안하게, 입력 완료 후 검색동작 실행
  // * .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) encoding 동작 예시
  //   => San Antonio -> San%20Antonio
  // 1) sink 대신 assign을 사용해서 UI와 이벤트 값을 바인딩할 수도 있다.
  private func setupPublishers() {
    let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.cityTextField)
    // memory leak 방지를 위해 구독 시에는 항상 cancellable을 할당하여 관리해준다.
    self.cancellable = publisher.compactMap {
      ($0.object as! UITextField).text?
        .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // 500 밀리초 동안 연속 이벤트가 없을때 메인스레드에서 down stream 동작한다.
    .flatMap { city in
      return self.webService.fetchWeather(city: city) // flatMap으로 구독가능한 Publisher 형태로 반환할 수 있다.
        .catch { _ in Empty() }
        .map { weather in
          guard let temp = weather.temp else {
            return "😢..."
          }
          return "\(temp) 𝐟"
        } // Weather 데이터로 맵핑
    }.assign(to: \.text, on: self.temperatureLabel)
    
    // 2) sink로 UI와 이벤트를 바인딩
    /*
    let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self.cityTextField)
    self.cancellable = publisher.compactMap {
      ($0.object as! UITextField).text?
        .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // 500 밀리초 동안 연속 이벤트가 없을때 메인스레드에서 down stream 동작한다.
    .flatMap { city in
      return self.webService.fetchWeather(city: city) // flatMap으로 구독가능한 Publisher 형태로 반환할 수 있다.
        .catch { _ in Empty() }
        .map { $0 } // Weather 데이터로 맵핑
    }.sink {
      guard let temp = $0.temp else {
        self.temperatureLabel.text = "😢"
        return
      }
      self.temperatureLabel.text = "\(temp) 𝐟"
    }
     */
  }
}

