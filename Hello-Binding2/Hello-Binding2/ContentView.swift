//
//  ContentView.swift
//  Hello-Binding2
//
//  Created by MinKyeongTae on 2022/09/28.
//

import SwiftUI

struct ContentView: View {
  
  @State private var name: String = "Hello"
  private func printName() {
    print(self.name)
  }

  var body: some View {
    VStack {
      Text(name)
      /// State 변수, name을 TextField와 바인딩 하여 텍스트필드의 입력값이 바뀔때마다 name 값도 바꾸기ㅔ 된다.
      TextField(text: $name, label: {
        Text("Enter name")
      })
      .padding(12)
      
      Button(action: printName) {
        Text("Show Name Value")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
