//: A UIKit based Playground for presenting user interface

import UIKit
import Combine
import PlaygroundSupport

// MARK: - Section 9. Combine Timers
// MARK: 56. Using Runloop
// RunLoop은 timer 기능을 제공합니다. RunLoop.main 을 사용하면 메인스레드에서 timer 이벤트를 사용할 수 있습니다.
// RunLoop 이외의 방식으로도 Combine을 활용해서 타이머 기능을 사용할 수 있습니다.

class MyViewController : UIViewController {
  
//  private var cancellables = Set<AnyCancellable>()
  private let runLoop = RunLoop.main
  private var timerSubscription: Cancellable?
  
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
    timerSubscription = self.runLoop.schedule(
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
  }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
