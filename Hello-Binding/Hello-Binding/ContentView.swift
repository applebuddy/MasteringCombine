//
//  ContentView.swift
//  Hello-Binding
//
//  Created by MinKyeongTae on 2022/09/28.
//

import SwiftUI

struct ContentView: View {
  
  var model = Dish.all()
  @State private var isSpicy = false

  var body: some View {
    List {
      // * State 변수를 Binding 타입으로 사용할때에는 변수 앞에 $를 붙인다.
      Toggle(isOn: $isSpicy) {
        Text("Spicy")
          .font(.title)
      }
      // Spicy Toggle option에 맞는 메뉴만 리스트에 나오게 된다.
      ForEach(model.filter { $0.isSpicy == self.isSpicy }) { dish in
        HStack {
          Image(dish.imageURL)
            .resizable()
            .frame(width: 100, height: 100)
          Text(dish.name)
            .font(.title)
            .lineLimit(nil)

          Spacer()

          if dish.isSpicy {
            Image("spicy-icon")
              .resizable()
              .frame(width: 35, height: 35)
          }
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
