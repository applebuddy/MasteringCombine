//
//  Task.swift
//  Adding-list-state
//
//  Created by MinKyeongTae on 2022/09/28.
//

import Foundation
import SwiftUI

// Identifiable protocol을 준수하기 위해서는 해당 객체의 고유 id를 설정해주어야 한다.
struct Task: Identifiable {
  let id = UUID()
  let name: String
}
