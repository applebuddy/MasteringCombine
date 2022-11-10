//
//  UIButton+Extension.swift
//  CombineCustomPublisherExample
//
//  Created by MinKyeongTae on 2022/11/11.
//

import UIKit
import Combine

extension UIControl {
  func throttleTapPublisher() -> Publishers.Throttle<UIControl.GesturePublisher<UIControl>, RunLoop> {
    return GesturePublisher(control: self, controlEvent: .touchUpInside)
      .throttle(
        for: .seconds(1),
        scheduler: RunLoop.main,
        latest: false
      )
  }
  
  struct GesturePublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never
    
    private let control: Control
    private let controlEvent: Control.Event
    
    init(control: Control, controlEvent: Control.Event) {
      self.control = control
      self.controlEvent = controlEvent
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
      let subscription = GestureSubscription(
        subscriber: subscriber,
        control: control,
        event: controlEvent
      )
      subscriber.receive(subscription: subscription)
    }
  }
  
  final class GestureSubscription<S: Subscriber, Control: UIControl>: Subscription
  where S.Input == Control {
    private var subscriber: S?
    private let control: Control
    
    init(subscriber: S, control: Control, event: UIControl.Event) {
      self.subscriber = subscriber
      self.control = control
      control.addTarget(self, action: #selector(eventHandler), for: event)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
      subscriber = nil
    }
    
    @objc func eventHandler() {
      _ = subscriber?.receive(control)
    }
  }
}

