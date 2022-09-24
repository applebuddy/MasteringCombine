//
//  ViewController.swift
//  HelloCombine
//
//  Created by MinKyeongTae on 2022/09/24.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK: - 9. Sending Notifications Using Publisher and Subscriber
    // MARK: - 10. Understanding Cancellable
    // functional programming
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

