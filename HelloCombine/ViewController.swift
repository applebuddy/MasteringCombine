//
//  ViewController.swift
//  HelloCombine
//
//  Created by MinKyeongTae on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa
import Combine

enum MyError: Error {
  case subscriberError
}

class StringSubscriber: Subscriber {
  // Publisher            Subscriber 의 상호 관계
  // <-------- subscribes
  //         gives subscription -->
  // <-------- requests values
  //         sends values -------->
  //         sends completion ---->
  
  // subscribe 이후, publisher로부터 subscription을 수신했을때 호출 됩니다.
  func receive(subscription: Subscription) {
    print("Received Subscription")
    subscription.request(.max(2)) // publiser야 최대 3개의 값만 줘봐
  }
  
  // publisher로부터 input 값을 수신했을때 호출됩니다.
  func receive(_ input: String) -> Subscribers.Demand {
    print("Received value : \(input)")
    return .none // publisher한테 더이상 받을 것 없어
//    return .max(1)
//    return .unlimited // 줄 수 있는거 다 받을래
  }
  
  // publisher가 publish 이벤트를 마쳤을때 호출 됩니다.
  func receive(completion: Subscribers.Completion<MyError>) {
    print("Completed")
  }

  typealias Input = String
  typealias Failure = MyError // Failure를 Never로 지정하면 fail이 발생하지 않습니다.
}

class ViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
//  private let cancellables = Set<Cancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK: - 12. Subjects
    // Subjects : Subject는 이벤트를 방출할 수 있는 Publisher이면서, 구독이 가능한 Subscriber도 될 수 있습니다.
    // * RxSwift의 Subject는 이벤트를 방출할 수 있는 Observable이면서 동시에 구독이 가능한 Observer입니다.
    // - Publisher
    // - Subscriber
    let subscriber = StringSubscriber()
    let subject = PassthroughSubject<String, MyError>()
    // subject는 Publisher처럼 구독이 가능합니다. 즉, Subscriber가 구독하여 이벤트를 받을 수 있으며, subject에서 원할때 이벤트를 Subscriber로 보낼 수 있습니다.
    // 1) Subscriber는 Subject를 구독할 수 있습니다.
    subject.subscribe(subscriber)

    // 2) Subject는 이벤트를 방출할 수도 있습니다.
    let subscription = subject.sink { completion in
      print("Received Completion from sink")
    } receiveValue: { value in
      print("Received Value from sink, value : \(value)")
    }

    subject.send("A") // Received value : A
    subject.send("B") // Received value : B
    subject.send("C") // .max(2)로 request를 했을 경우, 세번째 이벤트인 C는 방출되지 않습니다. input을 받을때 .none 대신 .max(1)을 반환하면 이벤트를 추가로 받을 수 있다.
    subject.send("B")
    
    subscription.cancel()
    
    subject.send("ㅜㅜ") // 구독이 취소되면 이후 이벤트는 방출되지 않아요.
    subject.send("ㅠㅠ")
    
    // MARK: - 11. Implementing a Subscriber
    /*
    let publisher = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"].publisher
    let subscriber = StringSubscriber()
    publisher.subscribe(subscriber)
    // 출력 결과 -> .max(3)으로 request를 했으므로 "A", "B", "C" 세개의 이벤트를 받습니다.
    // * unlimited로 input을 받는 경우, 모든 이벤트를 받습니다.
    /*
    Received Subscription
    Received value : A
    Received value : B
    Received value : C
     */
     */

    // MARK: - 9. Sending Notifications Using Publisher and Subscriber
    // MARK: - 10. Understanding Cancellable
    // functional programming
    /*
    let notification = Notification.Name("MyNotification")
    let publisher = NotificationCenter.default.publisher(for: notification, object: nil)
    NotificationCenter.default.post(name: notification, object: nil)
    
    // Combine의 publisher는 구독(sink)이 가능하다. 클로져를 통해 구독한 publisher의 이벤트를 수신 받을 수 있다.
    // * RxSwift의 Observable은 subscribe가 가능하다.
    // sink는 AnyCancellable타입을 반환한다. RxSwift의 subscribe가 Disposable을 반환하는 것과 유사하다.
    // RxSwift의 subscribe는 Disposable 타입을 반환 / Combine의 sink는 AnyCancellable을 반환
    let disposable = NotificationCenter.default.rx.notification(notification)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { _ in
        print("RxSwift Notification received")
      })
    
    let subscription = publisher.sink { _ in
      print("Combine Notification received")
    }
    
    // 구독 중의 이벤트는 받을 수 있다. 구독한 Observable, Publisher의 이벤트를 전달 받는다.
    NotificationCenter.default.post(name: notification, object: nil)
    
    // News Paper를 예로 들어보자. 구독을 하다가, 취소를 해야 신물을 그만 볼 수 있다.
    // Tuesday -> Delivered
    // Wednesday -> Delivered
    // Thursday -> Delivered
    // AnyCancellable의 cancel()을 통해 구독을 취소할 수 있다.
    disposable.dispose()
    subscription.cancel()
    
    // 구독 취소 후의 Observable, Publiisher 이벤트는 받을 수 없다.
    NotificationCenter.default.post(name: notification, object: nil)
    */

    // imparative programming (명령형 프로그래밍) 예시
    /*
    let notification = Notification.Name("MyNotification")
    let center = NotificationCenter.default
    
    // notification 옵저버 추가
    let observer = center.addObserver(forName: notification, object: nil, queue: nil) { notification in
      print("Notification received-!!")
    }
    
    // notification 이벤트 전달
    center.post(name: notification, object: nil)
    
    // notification 옵저버 제거
    center.removeObserver(observer)
     */
  }
}

