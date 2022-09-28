//
//  ContentView.swift
//  Adding-list-state
//
//  Created by MinKyeongTae on 2022/09/28.
//

// MARK: 77. Adding Items to List Maintained by State

import SwiftUI

struct ContentView: View {
  
  @State private var tasks = [Task]()
  private func addTask() {
    // @State 배열에 데이터를 추가하여 View의 List를 업데이트 시킬 수 있다.
    // State를 변화해서 View를 업데이트할때에는 항상 Sync 상태여야한다.
    self.tasks.append(Task(name: "Wash the car"))
  }
  
  var body: some View {
    List {
      Button(action: addTask) {
        Text("Add Task")
      }
      ForEach(tasks) { task in
        Text(task.name)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
