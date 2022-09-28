//
//  ContentView.swift
//  Understand-ObservableObject2
//
//  Created by MinKyeongTae on 2022/09/28.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var userSettings = UserSettings()
  
  var body: some View {
    // @ObservableObject인 userSettings의 @Published 변수, score를 사용하고 있다. score가 변화할때마다 View가 업데이트 된다.
    VStack {
      Text("\(userSettings.score)")
        .font(.largeTitle)
      Button("Increment Score") {
        // Increment Score 버튼을 선택하면 score값이 증가하며, 증가할때마다 View도 업데이트 됩니다.
        self.userSettings.score += 1
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
