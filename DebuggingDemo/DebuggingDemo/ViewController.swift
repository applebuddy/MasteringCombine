//
//  ViewController.swift
//  DebuggingDemo
//
//  Created by Mohammad Azam on 10/20/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

// MARK: 55. Using debugger with Combine
// breakpoint operator는 특정 조건이 충족될때 디버깅모드로 진입할 수 있습니다. breakpoint처럼 디버깅에 사용할 수 있습니다.
import UIKit
import Combine

class ViewController: UIViewController {
  
  private var cancellable: AnyCancellable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let publisher = (1...10).publisher
    self.cancellable = publisher
      .breakpoint(receiveOutput: { value in
        return value > 9
      })
      .sink {
      print($0)
    }
  }
}

