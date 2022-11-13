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
  @IBOutlet weak var centerLabel: UILabel!
  private var cancellables = Set<AnyCancellable>()
  private var buttonTapCount = 0
  private var labelTapCount = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    centerButton.throttleTapPublisher()
      .receive(on: RunLoop.main)
      .map { [weak self] _ in
        self?.buttonTapCount += 1
        return "throttleTap count : \(self?.buttonTapCount ?? 0)"
      }
      .sink { [weak self] title in
        self?.centerButton.setTitle(title, for: .normal)
      }
      .store(in: &cancellables)
    
    centerLabel.isUserInteractionEnabled = true
    centerLabel.throttleTapGesturePublisher()
      .receive(on: RunLoop.main)
      .map { [weak self] _ in
        self?.labelTapCount += 1
        return "throttleTap count : \(self?.labelTapCount ?? 0)"
      }
      .assign(to: \.text, on: centerLabel)
      .store(in: &cancellables)
  }
}
