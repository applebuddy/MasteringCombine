//
//  ContentView.swift
//  Understand-ObservableObject2
//
//  Created by MinKyeongTae on 2022/09/28.
//

// MARK: 83. Another Example of ObservableObject
// MARK: 84. Understanding @EnvironmentObject
// 'What is the @EnvironmentObject?'
// View 간 인자를 주고받으며 데이터 Binding이 가능했지만 전부 일일히 인자를 주고받으며 바인딩 이벤트를 처리하는게 안맞을때가 있을 수 있다.
// 이렇게 보다 광범위한 곳에서 공통적으로 사용하는 변수일 경우, @EnvironmentObject annotation으로 정의하여 사용할 수도 있다.

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var userSettings: UserSettings
  
  var body: some View {
    // @ObservableObject인 userSettings의 @Published 변수, score를 사용하고 있다. score가 변화할때마다 View가 업데이트 된다.
    VStack {
      Text("\(userSettings.score)")
        .font(.largeTitle)
      Button("Increment Score") {
        // Increment Score 버튼을 선택하면 score값이 증가하며, 증가할때마다 View도 업데이트 됩니다.
        self.userSettings.score += 1
      }
      
      // score 값을 FancyScoreView에도 공유할 수 있는 방법이 없을까?
      // Published 변수를 바인딩하기 위에 ContentView에 선언한 userSettings 인스턴스 앞에 $를 붙여준다.
      // ObservedObject가 아닌 @EnvironmentObject의 Published 변수를 접근하려는 경우, 인자로 넘길 필요가 없다. @EnvironmentObject는 해당 ContentView의 모든 Subviews에서 사용 가능하기 때문이다.
      FancyScoreView()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
