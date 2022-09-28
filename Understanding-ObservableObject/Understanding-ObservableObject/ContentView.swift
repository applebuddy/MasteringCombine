//
//  ContentView.swift
//  Understanding-ObservableObject
//
//  Created by MinKyeongTae on 2022/09/28.
//

import SwiftUI

struct ContentView: View {
  // ObservableObject를 사용하려면, @ObservedObject로 선언하면 된다.
  // 선언 후에는 @ObservedObject의 @Published 변수의 변화를 감지하게 된다.
  @ObservedObject var fancyTimer = FancyTimer()
  
  var body: some View {
    // @ObservedObject의 @Pubished 변수를 사용하므로, @Published 변수가 바뀔때마다 View도 업데이트 된다.
    Text("\(self.fancyTimer.value)")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
