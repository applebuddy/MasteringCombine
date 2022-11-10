//
//  ViewController.swift
//  CombineCustomPublisherExample
//
//  Created by MinKyeongTae on 2022/11/11.
//

import UIKit
import Combine

class ViewController: UIViewController {

  @IBOutlet weak var centerButton: UIButton!
  private var cancellables = Set<AnyCancellable>()
  private var tapCount = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    centerButton.throttleTapPublisher()
      .map { [weak self] _ in
        self?.tapCount += 1
        return "throttleTap count : \(self?.tapCount ?? 0)"
      }
      .sink { [weak self] title in
        self?.centerButton.setTitle(title, for: .normal)
      }
      .store(in: &cancellables)
  }
}

