//
//  ViewController.swift
//  HelloCombine
//
//  Created by MinKyeongTae on 2022/09/24.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // imparative programming (명령형 프로그래밍) 예시
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
  }
}

