//
//  FancyTimer.swift
//  Understanding-ObservableObject
//
//  Created by MinKyeongTae on 2022/09/28.
//

import Foundation
import SwiftUI
import Combine

class FancyTimer: ObservableObject {
  // FancyTimer를 바인딩하여 사용하는 곳에서는 @published 지정이 된 변수들이 최신값을 받게 된다.
  @Published var value: Int = 0
  
  init() {
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
      self.value += 1
    }
  }
}
