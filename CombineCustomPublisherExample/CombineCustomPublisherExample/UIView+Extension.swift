//
//  UIView+Extension.swift
//  CombineCustomPublisherExample
//
//  Created by MinKyeongTae on 2022/11/13.
//

import UIKit
import Combine

extension UIView {
  func throttleTapGesturePublisher() -> Publishers.Throttle<UITapGestureRecognizer.GesturePublisher<UITapGestureRecognizer>, RunLoop> {
    return UITapGestureRecognizer.GesturePublisher(recognizer: .init(), view: self)
      .throttle(
        for: .seconds(1),
        scheduler: RunLoop.main,
        latest: false
      )
  }
}
