//
//  Understand_ObservableObject2App.swift
//  Understand-ObservableObject2
//
//  Created by MinKyeongTae on 2022/09/28.
//

import SwiftUI

@main
struct Understand_ObservableObject2App: App {
    var body: some Scene {
        WindowGroup {
          // View의 environmentObject 메서드를 통해 ObservableObject를 전달할 수 있다.
          // environmentObject를 통해 전달된 ObservableObject는 해당 ContentView 뿐만 아니라 ContentView의 모든 Subviews에서 사용이 가능해진다.
          ContentView().environmentObject(UserSettings())
        }
    }
}
