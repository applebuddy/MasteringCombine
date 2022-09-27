//: A UIKit based Playground for presenting user interface

import UIKit
import Combine
import PlaygroundSupport

class MyViewController : UIViewController {
  
  //  private var cancellables = Set<AnyCancellable>()
  private var timerSubscription: Cancellable?
  private var cancellable: AnyCancellable?
  private let runLoop = RunLoop.main
  
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white
    
    let label = UILabel()
    label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
    label.text = "Hello World!"
    label.textColor = .black
    
    view.addSubview(label)
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.usingTimerClass_57()
  }
  
  // MARK: 57. Timer class
  // RunLoop 방식 이외로도 Timer class의 publish 타입 메서드를 사용하면 타이머 기능을 구현할 수 있다.
  // * autoconnect() : upstream connectable publisher에 자동적으로 연결을 시켜주는 메서드이다.
  private func usingTimerClass_57() {
    // 1초마다 메인스레드에서 타이머를 동작 시킨다.
    cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
      .autoconnect()
      .scan(0) { counter, _ in
        counter + 1 // scan operator를 사용하여 timer 호출 당 1씩 증가 시킨다.
      }
      .sink { value in
        print("Timer Fired! \(value)")
      }
  }
  
  // MARK: - Section 9. Combine Timers
  // MARK: 56. Using Runloop
  // RunLoop은 timer 기능을 제공합니다. RunLoop.main 을 사용하면 메인스레드에서 timer 이벤트를 사용할 수 있습니다.
  // RunLoop 이외의 방식으로도 Combine을 활용해서 타이머 기능을 사용할 수 있습니다.
  private func usingRunLoop_56() {
    /*
    self.cancellable = self.runLoop.schedule(
      after: runLoop.now,
      interval: .seconds(2), // 2초 간격으로 타이머를 실행합니다.
      tolerance: .milliseconds(100) // 타이머 허용 오차를 지정합니다.
    ) {
      print("Timer fired")
    }
    
    self.runLoop.schedule(
      after: .init(Date(timeIntervalSinceNow: 3.0))
    ) { [weak self] in
      // 3초 뒤 구독을 취소하면서 타이머를 종료 시킬 수 있다.
      print("timer cancelled")
      self?.timerSubscription?.cancel()
    }
     */
  }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
