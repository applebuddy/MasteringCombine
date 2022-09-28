//
//  UserSettings.swift
//  Understand-ObservableObject2
//
//  Created by MinKyeongTae on 2022/09/28.
//

import Foundation
import SwiftUI
import Combine

class UserSettings: ObservableObject {
  @Published var score: Int = 0
}
