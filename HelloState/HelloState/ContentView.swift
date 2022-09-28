//
//  ContentView.swift
//  HelloState
//
//  Created by MinKyeongTae on 2022/09/28.
//

// MARK: 77. Implementing State
// SwiftUI View 업데이트를 위해 State를 활용해봅니다.
import SwiftUI

struct ContentView: View {
  // State Variable은 변수 앞에 @State를 붙여서 사용한다.
  @State private var name: String = "John"
  
  var body: some View {
    VStack {
      Text(name)
        .font(.largeTitle)
      Button(action: {
        // SwiftUI View를 바꾸기 위해서는 State 변수를 사용해야 한다.
        // Button을 클릭하면 "John" -> "Mary"로 State 변수 값이 바뀌며, View도 새롭게 업데이트 된다.
        self.name = "Mary"
      }) {
        Text("Change Name")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
