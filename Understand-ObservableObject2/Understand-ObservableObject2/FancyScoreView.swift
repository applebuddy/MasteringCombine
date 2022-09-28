//
//  FancyScoreView.swift
//  Understand-ObservableObject2
//
//  Created by MinKyeongTae on 2022/09/28.
//

import SwiftUI

struct FancyScoreView: View {
  // @EnvironmentObject는 Global State같은 개념으로, ContentView 이 외 많은 Subviews에서 접근이 필요한 바인딩 값이 필요한 경우 사용할 수 있다.
  @EnvironmentObject var userSettings: UserSettings

  var body: some View {
    VStack {
      Text("\(self.userSettings.score)")
      Button("Increment Score") {
        self.userSettings.score += 1
      }.background(.green)
    }
    .padding()
    .background(.orange)
  }
}

struct FancyScoreView_Previews: PreviewProvider {
  static var previews: some View {
    FancyScoreView()
  }
}
