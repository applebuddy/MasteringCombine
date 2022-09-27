//
//  ContentView.swift
//  Hello-SwiftUI
//
//  Created by MinKyeongTae on 2022/09/28.
//

// MARK: - Secion 13. SwiftUI Basics
// MARK: 71 ~ 73. SwiftUI Basic function Practice

import SwiftUI

struct ContentView: View {
  // if you use SwiftUI, you can view your preview before debugging.
  var body: some View {
    VStack(alignment: .center) {
      Image("icon")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, 30.0)
        .cornerRadius(50.0)
//        .clipShape(Circle()) // 둥글게 모양을 잘라내어 보이게하려면 사용
      
      Text("The Complete iOS 13 Course")
        .font(.largeTitle)
        .foregroundColor(.green)
        .multilineTextAlignment(.center)
      Text("Second Line")
        .font(.title)
        .foregroundColor(.orange)
      
      HStack {
        Text("Left Side")
        Text("Right Side")
          .padding(.all)
      }
    }
    .ignoresSafeArea(.all, edges: .top)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
